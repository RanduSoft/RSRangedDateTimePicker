//
//  RSRangedDateTimePickerView - Coordinator
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import Foundation
import UIKit

extension PickerView {
    public class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: PickerView
        var config: Config {
            self.parent.config
        }

        var minimumRangeDurationInMinutes: Int {
            config.minutesInterval * config.minimumMultipleOfMinutesIntervalForRangeDuration
        }

        var startDateComponentStartDate: Date = Date()
        var endDateComponentStartDate: Date = Date()

        init(_ pickerView: PickerView) {
            self.parent = pickerView
        }

        public func numberOfComponents(in pickerView: UIPickerView) -> Int {
            self.parent.style.isRange ? 2 : 1
        }

        public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.numberOfDatesForComponent(component)
        }

        public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch self.parent.style {
                case .dateRange(let formatter), .timeRange(let formatter), .date(let formatter), .time(let formatter):
                    return formatter.string(from: date(component: component, row: row))
            }
        }

        public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch parent.style {
                case .dateRange, .timeRange:
                    if selectedRow(forComponent: 0, in: pickerView) > selectedRow(forComponent: 1, in: pickerView) {
                        selectRow(selectedRow(forComponent: 0, in: pickerView), inComponent: 1, in: pickerView)
                    }

                    let startDate = date(component: 0, row: selectedRow(forComponent: 0, in: pickerView))
                    let endDate = date(component: 1, row: selectedRow(forComponent: 1, in: pickerView))

                    if parent.style.isTime {
                        parent.selectedRange = DateRange(
                            start: extractTimeFrom(date: startDate),
                            end: extractTimeFrom(date: endDate)
                        )
                    } else {
                        parent.selectedRange = DateRange(start: startDate, end: endDate)
                    }
                case .date, .time:
                    let startDate = date(component: 0, row: selectedRow(forComponent: 0, in: pickerView))

                    if parent.style.isTime {
                        parent.selectedDate = extractTimeFrom(date: startDate)
                    } else {
                        parent.selectedDate = startDate
                    }
            }
        }

        // MARK: - Accessibility

        public func pickerView(_ pickerView: UIPickerView, accessibilityLabelForComponent component: Int) -> String? {
            guard parent.style.isRange else { return nil }
            return component == 0 ? "Start" : "End"
        }
    }
}
