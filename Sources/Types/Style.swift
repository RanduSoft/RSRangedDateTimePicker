//
//  RSRangedDateTimePickerView - Style
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import Foundation

extension RSRangedDateTimePickerView {
     public enum Style {
        case dateRange(formatter: DateFormatter = RSRangedDateTimePickerView.Style.defaultDateFormatter)
        case timeRange(formatter: DateFormatter = RSRangedDateTimePickerView.Style.defaultTimeFormatter)
        
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
