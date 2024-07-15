//
//  RSRangedDateTimePickerView - Coordinator+Helpers
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import Foundation
import UIKit

extension RSRangedDateTimePickerView.Coordinator {
    func startDate(component: Int) -> Date {
        let startDate: Date
        if component == 0 {
            startDate = self.startDateComponentStartDate
        } else {
            startDate = self.endDateComponentStartDate
        }
        
        return startDate
    }
    
    func date(component: Int, row: Int) -> Date {
        return Date(
            timeInterval: TimeInterval(row * self.parent.config.minutesInterval * 60),
            since: self.startDate(component: component)
        )
    }
    
    func row(date: Date, component: Int) -> Int {
        let minutesSinceStartDate = max(date.timeIntervalSince(startDate(component: component)) / 60, 0)
        return Int(minutesSinceStartDate) / self.parent.config.minutesInterval
    }
    
    func numberOfDatesForComponent(_ component: Int) -> Int {
        let calendar = self.parent.config.calendar
        
        let startOfDay = calendar.startOfDay(for: self.startDateComponentStartDate)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!.addingTimeInterval(-1)
        
        var adjustedMaximumDate: Date!
        
        switch self.parent.style {
            case .dateRange:
                adjustedMaximumDate = self.parent.config.maximumDate
            case .timeRange:
                adjustedMaximumDate = min(self.parent.config.maximumDate, endOfDay)
        }
        
        let minutesBetweenDates = ceil(
            adjustedMaximumDate.timeIntervalSince(self.startDateComponentStartDate) / 60.0
            - Double(self.minimumRangeDurationInMinutes)
        )
        return Int(minutesBetweenDates / Double(self.parent.config.minutesInterval))
    }
    
    func refreshDates() {
        let calendar = self.parent.config.calendar
        
        switch self.parent.style {
            case .dateRange:
                let dateComponents = calendar.dateComponents([.year, .month, .day], from: self.parent.config.minimumDate)
                
                self.startDateComponentStartDate = calendar.date(from: dateComponents)!
                self.endDateComponentStartDate = Date(
                    timeInterval: 0,
                    since: self.startDateComponentStartDate
                )
            case .timeRange:
                var dateComponents = calendar.dateComponents([
                    .year, .month, .day,
                    .minute, .hour, .second
                ], from: calendar.startOfDay(for: Date()))
                
                dateComponents.minute = Int(
                    ceil(
                        Double(dateComponents.minute ?? 0) /
                        Double(self.parent.config.minutesInterval)
                    ) * Double(self.parent.config.minutesInterval)
                )
                dateComponents.second = 0
                
                self.startDateComponentStartDate = calendar.date(from: dateComponents)!
                self.endDateComponentStartDate = Date(
                    timeInterval: TimeInterval(self.minimumRangeDurationInMinutes * 60),
                    since: self.startDateComponentStartDate
                )
        }
    }
    
    func extractTimeFrom(date: Date) -> Date {
        return self.parent.config.calendar.date(from:
            self.parent.config.calendar.dateComponents(
                [.hour, .minute], from: date
            )
        )!
    }
}
