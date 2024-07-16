# RSRangedDateTimePicker

RSRangedDateTimePicker is a versatile SwiftUI and UIKit compatible library for displaying customizable date and time pickers with range selection support.

| | |
|:-------------------------:|:-------------------------:|
|<img width="800" alt="date" src="https://github.com/RanduSoft/RSRangedDateTimePicker/blob/master/Resources/date.png"> `style = .date` | <img width="800" alt="time" src="https://github.com/RanduSoft/RSRangedDateTimePicker/blob/master/Resources/time.png"> `style = .time` |
|<img width="800" alt="dateRange" src="https://github.com/RanduSoft/RSRangedDateTimePicker/blob/master/Resources/dateRange.png"> `style = .dateRange` | <img width="800" alt="timeRange" src="https://github.com/RanduSoft/RSRangedDateTimePicker/blob/master/Resources/timeRange.png"> `style = .timeRange`|

## Features

- SwiftUI and UIKit compatible
- Single date/time or range selection
- Customizable date and time formats
- Configurable minimum and maximum dates
- Adjustable time intervals
- Supports both modal presentation and in-view embedding

## Requirements

- iOS 16.0+
- Swift 5.10+

## Installation

### Swift Package Manager

Add the following line to your `Package.swift` file:

```swift
.package(url: "https://github.com/RanduSoft/RSRangedDateTimePicker.git", from: "1.0.0")
```

## Usage

Check out the `DemoView.swift` file or the examples below:

### SwiftUI
```swift
import SwiftUI
import RSRangedDateTimePicker

struct ContentView: View {
    @State private var dateRange = PickerView.DateRange(start: Date(), end: Date())
    
    var body: some View {
        VStack {
            PickerView(style: .dateRange(), selectedRange: $dateRange)
                .frame(height: 200)
            
            Text("Selected range: \(dateRange.start) - \(dateRange.end)")
        }
    }
}
```

### UIKit
```swift
import UIKit
import RSRangedDateTimePicker

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .system)
        button.setTitle("Show Picker", for: .normal)
        button.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
        view.addSubview(button)
        button.center = view.center
    }
    
    @objc func showPicker() {
        RSRangedDateTimePickerViewController.show(
            on: self,
            style: .dateRange(),
            onRangeSelected: { range in
                print("Selected range: \(range.start) - \(range.end)")
            }
        )
    }
    
    @objc func showPickerAlt() {
        let datePickerVC = RSRangedDateTimePickerViewController(style: .date())
        datePickerVC.onDateSelected = { newDate in
            print(newDate)
        }
        datePickerVC.onRangeSelected = { dateRange in
            print(dateRange.start, dateRange.end)
        }
        datePickerVC.onDismiss = {
            print("onDismiss")
        }
        datePickerVC.modalPresentationStyle = .overCurrentContext
        self.presentController(datePickerVC, animated: false)
    }
}
```

> [!NOTE]
> Each `style` will only use its `initial` (optional) variable. Make sure to use
> 
> `initialDate` for `style = .date / .time`
> 
> or
> 
> `initialRange` for `style = .dateRange / .timeRange`

## Customization

You can customize the picker's appearance and behavior by adjusting the `Style` and `Config` parameters:

```swift
let customConfig = PickerView.Config(
    minimumDate: Date(),
    maximumDate: Date().addingTimeInterval(86400 * 30),
    minutesInterval: 30,
    minimumMultipleOfMinutesIntervalForRangeDuration: 2,
    calendar: Calendar.current
)

let customStyle = PickerView.Style.dateRange(formatter: {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d, yyyy"
    return formatter
}())
```

Use these `customStyle` and `customConfig` in both `SwiftUI` and `UIKit`.

The "Save" button foreground color is the app tint color and cannot be changed at this time.

## License
RSRangedDateTimePicker is available under the **MPL-2.0 license**. See the [LICENSE](https://github.com/RanduSoft/RSRangedDateTimePicker/blob/master/LICENSE) file for more info.
