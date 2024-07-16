//
//  RSRangedDateTimePickerView - Style
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import Foundation

extension PickerView {
    public enum Style {
        case date(formatter: DateFormatter = PickerView.Style.defaultDateFormatter)
        case dateRange(formatter: DateFormatter = PickerView.Style.defaultDateFormatter)
        case time(formatter: DateFormatter = PickerView.Style.defaultTimeFormatter)
        case timeRange(formatter: DateFormatter = PickerView.Style.defaultTimeFormatter)
        
        public static var defaultDateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter
        }
        
        public static var defaultTimeFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter
        }
    }
}

