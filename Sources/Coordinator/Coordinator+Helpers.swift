//
//  RSRangedDateTimePickerView - Coordinator+Helpers
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import Foundation
import UIKit

extension PickerView.Coordinator {
    func startDate(component: Int) -> Date {
        let startDate: Date
        if component == 0 {
            startDate = startDateComponentStartDate
        } else {
            startDate = endDateComponentStartDate
        }
        
        return startDate
    }
    
    func date(component: Int, row: Int) -> Date {
        Date(timeInterval: TimeInterval(row * config.minutesInterval * 60), since: startDate(component: component))
    }
    
    func row(date: Date, component: Int) -> Int {
        let minutesSinceStartDate = max(date.timeIntervalSince(startDate(component: component)) / 60, 0)
        return Int(minutesSinceStartDate) / config.minutesInterval
    }
    
    func numberOfDatesForComponent(_ component: Int) -> Int {
        let calendar = config.calendar
        
        let startOfDay = calendar.startOfDay(for: startDateComponentStartDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!.addingTimeInterval(-1)
        
        var adjustedMaximumDate: Date!
        
        switch parent.style {
            case .dateRange, .date:
                adjustedMaximumDate = config.maximumDate
            case .timeRange, .time:
                adjustedMaximumDate = min(config.maximumDate, endOfDay)
        }
        
        let minutesBetweenDates = ceil(
            adjustedMaximumDate.timeIntervalSince(startDateComponentStartDate) / 60.0
            - 
            Double(minimumRangeDurationInMinutes)
        )
        return Int(minutesBetweenDates / Double(config.minutesInterval))
    }
    
    func refreshDates() {
        let calendar = self.parent.config.calendar
        
        switch self.parent.style {
            case .dateRange, .date:
                let dateComponents = calendar.dateComponents([
                    .year, .month, .day
                ], from: config.minimumDate)
                
                self.startDateComponentStartDate = calendar.date(from: dateComponents)!
                self.endDateComponentStartDate = Date(
                    timeInterval: 0,
                    since: startDateComponentStartDate
                )
            case .timeRange, .time:
                var dateComponents = calendar.dateComponents([
                    .year, .month, .day,
                    .minute, .hour, .second
                ], from: calendar.startOfDay(for: Date()))
                
                dateComponents.minute = Int(
                    ceil(
                        Double(dateComponents.minute ?? 0) /
                        Double(config.minutesInterval)
                    ) * Double(config.minutesInterval)
                )
                dateComponents.second = 0
                
                self.startDateComponentStartDate = calendar.date(from: dateComponents)!
                self.endDateComponentStartDate = Date(
                    timeInterval: TimeInterval(minimumRangeDurationInMinutes * 60),
                    since: startDateComponentStartDate
                )
        }
    }
    
    func extractTimeFrom(date: Date) -> Date {
        return config.calendar.date(from:
            config.calendar.dateComponents(
                [.hour, .minute], from: date
            )
        )!
    }
}

extension PickerView.Coordinator {
    func selectRow(_ row: Int, inComponent component: Int, in pickerView: UIPickerView, animated: Bool = true) {
        guard pickerView.numberOfComponents > component else {
            return
        }
        
        pickerView.selectRow(row, inComponent: component, animated: animated)
    }
    
    func selectedRow(forComponent component: Int, in pickerView: UIPickerView) -> Int {
        guard pickerView.numberOfComponents > component else {
            return 0
        }
        
        return pickerView.selectedRow(inComponent: component)
    }
}
