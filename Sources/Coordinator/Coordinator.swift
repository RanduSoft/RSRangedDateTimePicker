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
        
        var startDateComponentStartDate: Date!
        var endDateComponentStartDate: Date!
        
        init(_ pickerView: PickerView) {
            self.parent = pickerView
        }
        
        public func numberOfComponents(in pickerView: UIPickerView) -> Int {
            switch self.parent.style {
                case .date, .time: 1
                case .dateRange, .timeRange: 2
            }
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
            if selectedRow(forComponent: 0, in: pickerView) > selectedRow(forComponent: 1, in: pickerView) {
                selectRow(selectedRow(forComponent: 0, in: pickerView), inComponent: 1, in: pickerView)
            }
            
            let startDate = date(component: 0, row: selectedRow(forComponent: 0, in: pickerView))
            let endDate = date(component: 1, row: selectedRow(forComponent: 1, in: pickerView))
            
            switch parent.style {
                case .dateRange:
                    parent.selectedRange = DateRange(start: startDate, end: endDate)
                case .timeRange:
                    parent.selectedRange = DateRange(
                        start: extractTimeFrom(date: startDate),
                        end: extractTimeFrom(date: endDate)
                    )
                case .date :
                    parent.selectedDate = startDate
                case .time:
                    parent.selectedDate = extractTimeFrom(date: startDate)
            }
        }
    }
}
