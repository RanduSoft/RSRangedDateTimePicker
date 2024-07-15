//
//  RSRangedDateTimePickerView - Coordinator
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import Foundation
import UIKit

extension RSRangedDateTimePickerView {
    public class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: RSRangedDateTimePickerView
        
        var minimumRangeDurationInMinutes: Int {
            return self.parent.config.minutesInterval *
            self.parent.config.minimumMultipleOfMinutesIntervalForRangeDuration
        }
        
        var startDateComponentStartDate: Date!
        var endDateComponentStartDate: Date!
        
        init(_ pickerView: RSRangedDateTimePickerView) {
            self.parent = pickerView
        }
        
        public func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 2
        }
        
        public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.numberOfDatesForComponent(component)
        }
        
        public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch self.parent.style {
                case .dateRange(let formatter):
                    return formatter.string(from: self.date(component: component, row: row))
                case .timeRange(let formatter):
                    return formatter.string(from: self.date(component: component, row: row))
            }
        }
        
        public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if pickerView.selectedRow(inComponent: 0) > pickerView.selectedRow(inComponent: 1) {
                pickerView.selectRow(pickerView.selectedRow(inComponent: 0), inComponent: 1, animated: true)
            }
            
            switch self.parent.style {
                case .dateRange:
                    self.parent.selectedRange = DateRange(
                        start: self.date(component: 0, row: pickerView.selectedRow(inComponent: 0)),
                        end: self.date(component: 1, row: pickerView.selectedRow(inComponent: 1))
                    )
                case .timeRange:
                    self.parent.selectedRange = DateRange(
                        start: self.extractTimeFrom(date:
                                                        self.date(component: 0, row: pickerView.selectedRow(inComponent: 0))
                                                   ),
                        end: self.extractTimeFrom(date:
                                                    self.date(component: 1, row: pickerView.selectedRow(inComponent: 1))
                                                 )
                    )
            }
        }
    }
}
