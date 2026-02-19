# RSRangedDateTimePicker - Code Review Report

## Bugs

### B1. Save button does not dismiss the sheet
**File:** `Sources/RSRangedDateTimePickerView.swift:17,32-34`
**Severity:** High

`RSRangedDateTimePickerView` declares `@State private var showSheet: Bool = true` and the Save button toggles it, but **nothing observes this state**. The view has no `.sheet(isPresented:)` modifier — `.presentationDetents` and `.presentationDragIndicator` are just configuration modifiers for the parent sheet. Toggling `showSheet` has zero effect.

In standalone SwiftUI usage (as shown in the README), tapping Save does nothing — the user must swipe down to dismiss. In the UIKit path via `RSRangedDateTimePickerSheetView`, the child's `showSheet` is completely separate from the parent's `showSheet`, so it also does nothing.

**Fix:** Replace the local `showSheet` toggle with `@Environment(\.dismiss) var dismiss` and call `dismiss()` in the Save button action. Also invoke `onDismiss?()` so the callback fires.

---

### B2. `didSelectRow` accesses component 1 for single-selection styles
**File:** `Sources/Coordinator/Coordinator.swift:48-50`
**Severity:** Medium

For `.date` and `.time` styles, the picker has only 1 component, but `didSelectRow` always compares `selectedRow(forComponent: 0)` vs `selectedRow(forComponent: 1)`. The helper `selectedRow` safely returns `0` when the component doesn't exist, so this doesn't crash. However, the logic is incorrect — it may spuriously attempt to call `selectRow(_:inComponent:1:...)` on a single-component picker.

**Fix:** Wrap the range-constraint logic in a `switch` or guard so it only runs for `.dateRange` / `.timeRange` styles.

---

### B3. `numberOfDatesForComponent` ignores the component parameter for its start date
**File:** `Sources/Coordinator/Coordinator+Helpers.swift:32-53`
**Severity:** Medium

The method always uses `startDateComponentStartDate` regardless of which component is passed. For component 1 in range mode, the actual start date is `endDateComponentStartDate` (which includes the minimum range offset). The current formula compensates by subtracting `minimumRangeDurationInMinutes`, but this produces the same row count for both components — meaning component 1 can display dates that exceed `maximumDate` when the minimum range offset is large relative to the total range.

**Fix:** Use `startDate(component:)` instead of hardcoding `startDateComponentStartDate`, and only subtract `minimumRangeDurationInMinutes` for component 0 in range modes.

---

### B4. `minimumRangeDurationInMinutes` is subtracted for single-selection styles
**File:** `Sources/Coordinator/Coordinator+Helpers.swift:47-52`
**Severity:** Medium

`numberOfDatesForComponent` always subtracts `minimumRangeDurationInMinutes` from the available range. When using `.time` style with the default `.time` config (`minimumMultipleOfMinutesIntervalForRangeDuration = 3`), this removes 45 minutes from the selectable times even though range duration constraints are irrelevant for single selection.

**Fix:** Only subtract `minimumRangeDurationInMinutes` when the style is `.dateRange` or `.timeRange`.

---

### B5. Strong reference cycle in UIKit ViewController bindings
**File:** `Sources/RSRangedDateTimePickerVC.swift:45-56`
**Severity:** Medium

The `Binding` `get`/`set` closures capture `self` strongly:
```swift
Binding(
    get: { self.selectedDate },
    set: { newValue in self.selectedDate = newValue ... }
)
```
This creates a retain cycle: `VC → hostingController → SwiftUI view → binding closure → VC`. The `onDismiss` closure correctly uses `[weak self]`, but the binding closures do not.

**Fix:** Use `[weak self]` in the binding closures with appropriate fallback values.

---

### B6. README contains invalid UIKit method call
**File:** `README.md:114`
**Severity:** Low

The alternative UIKit example calls `self.presentController(datePickerVC, animated: false)` which is not a UIViewController method. Should be `self.present(datePickerVC, animated: false)`.

---

## Issues

### I1. Implicitly unwrapped optionals for component start dates
**File:** `Sources/Coordinator/Coordinator.swift:22-23`

`startDateComponentStartDate` and `endDateComponentStartDate` are declared as `Date!`. If any code path accesses them before `refreshDates()` is called, the app will crash. This is a fragile pattern.

**Suggestion:** Initialize them inline with a default value (e.g., `Date()`) and make them non-optional, or refactor `refreshDates()` to be called in the initializer.

---

### I2. Force unwraps throughout the codebase
**Files:** `Config.swift:30-31,40-41`, `Coordinator+Helpers.swift:36,64,83,92-96`

Multiple `calendar.date(byAdding:...)!` and `calendar.date(from:)!` calls could theoretically crash. While unlikely with standard calendars, this is defensive programming concern.

**Suggestion:** Use `guard let` with appropriate fallbacks, or at minimum document the invariants that make these safe.

---

### I3. `selectRow` doesn't validate row bounds
**File:** `Sources/Coordinator/Coordinator+Helpers.swift:101-107`

The helper validates `numberOfComponents > component` but doesn't validate `row < numberOfRows(inComponent:)`. An out-of-range row from a stale calculation could cause undefined UIPickerView behavior.

**Suggestion:** Add a row bounds check: `guard row >= 0, row < pickerView.numberOfRows(inComponent: component)`.

---

### I4. `DateRange` allows `start > end`
**File:** `Sources/Types/DateRange.swift:15-17`

The public initializer accepts any start/end dates without validation. While the Coordinator enforces ordering during user interaction, ranges created programmatically (e.g., initial values) could be invalid.

**Suggestion:** Add a precondition or swap dates if `start > end`.

---

### I5. `Config` properties lack validation
**File:** `Sources/Types/Config.swift:20-26`

No validation that `minutesInterval > 0`, `minimumDate < maximumDate`, or `minimumMultipleOfMinutesIntervalForRangeDuration >= 0`. A `minutesInterval` of 0 would cause a division-by-zero crash in `numberOfDatesForComponent` and `row(date:component:)`.

**Suggestion:** Add `precondition` checks or clamping in the initializer.

---

### I6. Deprecated `onChange(of:)` API
**Files:** `Sources/Views/DemoView.swift:50,52`, `Sources/RSRangedDateTimePickerSheetView.swift:37`

Uses the `onChange(of:) { newValue in }` form which is deprecated starting in iOS 17. Since the minimum target is iOS 16, it compiles but produces warnings in Xcode 15+.

**Suggestion:** Use the two-parameter form with availability checks, or suppress with `@available` if iOS 16 support is still needed.

---

### I7. `updateUIView` is empty — picker won't reflect external state changes
**File:** `Sources/Views/PickerView.swift:65-67`

If `selectedDate`, `selectedRange`, `config`, or `style` change externally after the picker is created, the UIPickerView won't update to reflect those changes. SwiftUI calls `updateUIView` for this purpose.

**Suggestion:** Implement `updateUIView` to sync the picker's selected rows with the current binding values, at minimum for `selectedDate` and `selectedRange`.

---

## Improvements

### P1. New `DateFormatter` allocated on every access of default formatters
**File:** `Sources/Types/Style.swift:17-27`

`defaultDateFormatter` and `defaultTimeFormatter` are computed properties that create a new `DateFormatter` each time they're called. `DateFormatter` is expensive to instantiate and this is invoked for every row title in the picker.

**Suggestion:** Use `static let` with a closure or a cached backing store.

---

### P2. Hardcoded "Save" button text — no localization
**File:** `Sources/RSRangedDateTimePickerView.swift:36`

The "Save" string is hardcoded in English. The library has no localization support.

**Suggestion:** Accept a custom button title via the initializer, or use `String(localized:)` with a bundle reference for built-in localization.

---

### P3. No accessibility labels for picker components
**Files:** `Sources/Coordinator/Coordinator.swift`

The UIPickerView components have no custom accessibility labels. VoiceOver users won't know that component 0 is "Start" and component 1 is "End" in range modes.

**Suggestion:** Implement `pickerView(_:accessibilityLabelForComponent:)` or set `accessibilityLabel` on the picker.

---

### P4. `presentationCornerRadius()` extension on `View` is overly generic
**File:** `Sources/RSRangedDateTimePickerView.swift:48-56`

A parameter-less `presentationCornerRadius()` extension on `View` is added to the global namespace. This is a public library — consumers could have naming collisions, and it shadows the system API name.

**Suggestion:** Make it `internal` or `private`, or rename it to something specific like `rsPickerPresentationCornerRadius()`.

---

### P5. No test target
**File:** `Package.swift`

The package has no test target. There are no unit tests for any of the logic (date calculations, row conversions, range enforcement, config validation).

**Suggestion:** Add a test target covering at minimum:
- `Coordinator+Helpers` date/row calculations
- `numberOfDatesForComponent` boundary conditions
- Range constraint enforcement in `didSelectRow`
- `Config` static presets
- `DateRange` equality

---

### P6. `DemoView` is compiled into the library target
**File:** `Sources/Views/DemoView.swift`

`DemoView` is a development/preview helper but it's included in the library target shipped to consumers. It adds unnecessary code to the compiled library.

**Suggestion:** Move it to a separate example target or wrap it in `#if DEBUG`.

---

### P7. `PickerView.Style` enum prevents pattern matching without extracting the formatter
**File:** `Sources/Types/Style.swift:11-15`

Every `switch` on `Style` must destructure the associated `formatter` value even when it's not needed (e.g., `case .date, .time:` in `numberOfComponents`). This makes the style checks verbose.

**Suggestion:** Add computed properties like `var isRange: Bool` and `var isTime: Bool` to simplify conditional logic throughout the codebase.

---

### P8. `Coordinator.parent` holds a stale copy of the struct
**File:** `Sources/Coordinator/Coordinator.swift:13`

`PickerView` is a struct, so `var parent: PickerView` in the Coordinator holds a snapshot from creation time. Bindings still work (they're reference-backed), but `parent.style` and `parent.config` are frozen at their initial values. This is the standard UIViewRepresentable pattern, but combined with the empty `updateUIView`, it means the coordinator can never react to external changes.

---

## Summary

| Category    | Count | Critical |
|-------------|-------|----------|
| Bugs        | 6     | B1 (Save button non-functional) |
| Issues      | 7     | I5 (division by zero possible)  |
| Improvements| 8     | P5 (no tests)                   |
