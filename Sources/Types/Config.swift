//
//  RSRangedDateTimePickerView - Config
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import Foundation

extension RSRangedDateTimePickerView {
    public struct Config {
        let minimumDate: Date
        let maximumDate: Date
        
        let minutesInterval: Int
        let minimumMultipleOfMinutesIntervalForRangeDuration: Int
        
        let calendar: Calendar
        
        static var date: Config {
            Config(
                minimumDate: Calendar.current.date(byAdding: .year, value: -1, to: Date())!,
                maximumDate: Calendar.current.date(byAdding: .year, value: 1, to: Date())!,
                minutesInterval: 1440,
                minimumMultipleOfMinutesIntervalForRangeDuration: 0,
                calendar: Calendar.current
            )
        }
        
        static var time: Config {
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
