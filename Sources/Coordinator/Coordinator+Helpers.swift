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
        component == 0 ? startDateComponentStartDate : endDateComponentStartDate
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
        let componentStartDate = startDate(component: component)

        let startOfDay = calendar.startOfDay(for: componentStartDate)
        guard let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)?.addingTimeInterval(-1) else {
            return 0
        }

        let adjustedMaximumDate: Date
        if parent.style.isTime {
            adjustedMaximumDate = min(config.maximumDate, endOfDay)
        } else {
            adjustedMaximumDate = config.maximumDate
        }

        let rangeDurationToSubtract: Double
        if parent.style.isRange && component == 0 {
            rangeDurationToSubtract = Double(minimumRangeDurationInMinutes)
        } else {
            rangeDurationToSubtract = 0
        }

        let minutesBetweenDates = ceil(
            adjustedMaximumDate.timeIntervalSince(componentStartDate) / 60.0 - rangeDurationToSubtract
        )
        return max(Int(minutesBetweenDates / Double(config.minutesInterval)), 0)
    }

    func refreshDates() {
        let calendar = self.parent.config.calendar

        switch self.parent.style {
            case .dateRange, .date:
                let dateComponents = calendar.dateComponents([
                    .year, .month, .day
                ], from: config.minimumDate)

                guard let startDate = calendar.date(from: dateComponents) else { return }
                self.startDateComponentStartDate = startDate
                self.endDateComponentStartDate = startDate

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

                guard let startDate = calendar.date(from: dateComponents) else { return }
                self.startDateComponentStartDate = startDate
                self.endDateComponentStartDate = Date(
                    timeInterval: TimeInterval(minimumRangeDurationInMinutes * 60),
                    since: startDate
                )
        }
    }

    func extractTimeFrom(date: Date) -> Date {
        config.calendar.date(from:
            config.calendar.dateComponents([.hour, .minute], from: date)
        ) ?? date
    }
}

extension PickerView.Coordinator {
    func selectRow(_ row: Int, inComponent component: Int, in pickerView: UIPickerView, animated: Bool = true) {
        guard pickerView.numberOfComponents > component else { return }
        let maxRow = pickerView.numberOfRows(inComponent: component)
        guard row >= 0, row < maxRow else { return }
        pickerView.selectRow(row, inComponent: component, animated: animated)
    }

    func selectedRow(forComponent component: Int, in pickerView: UIPickerView) -> Int {
        guard pickerView.numberOfComponents > component else { return 0 }
        return pickerView.selectedRow(inComponent: component)
    }
}
