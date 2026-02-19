//
//  RSRangedDateTimePickerView - Config
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import Foundation

extension PickerView {
    public struct Config {
        let minimumDate: Date
        let maximumDate: Date
        
        let minutesInterval: Int
        let minimumMultipleOfMinutesIntervalForRangeDuration: Int
        
        let calendar: Calendar
        
        public init(minimumDate: Date, maximumDate: Date, minutesInterval: Int, minimumMultipleOfMinutesIntervalForRangeDuration: Int, calendar: Calendar) {
            precondition(minutesInterval > 0, "minutesInterval must be greater than 0")
            precondition(minimumDate < maximumDate, "minimumDate must be before maximumDate")
            precondition(minimumMultipleOfMinutesIntervalForRangeDuration >= 0, "minimumMultipleOfMinutesIntervalForRangeDuration must be non-negative")

            self.minimumDate = minimumDate
            self.maximumDate = maximumDate
            self.minutesInterval = minutesInterval
            self.minimumMultipleOfMinutesIntervalForRangeDuration = minimumMultipleOfMinutesIntervalForRangeDuration
            self.calendar = calendar
        }
        
        public static var date: Config {
            Config(
                minimumDate: Calendar.current.date(byAdding: .year, value: -1, to: Date())!,
                maximumDate: Calendar.current.date(byAdding: .year, value: 1, to: Date())!,
                minutesInterval: 1440,
                minimumMultipleOfMinutesIntervalForRangeDuration: 0,
                calendar: Calendar.current
            )
        }
        
        public static var time: Config {
            Config(
                minimumDate: Calendar.current.date(byAdding: .year, value: -1, to: Date())!,
                maximumDate: Calendar.current.date(byAdding: .year, value: 1, to: Date())!,
                minutesInterval: 15,
                minimumMultipleOfMinutesIntervalForRangeDuration: 3,
                calendar: Calendar.current
            )
        }
    }
}
