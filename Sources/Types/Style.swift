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
        
        public static let defaultDateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter
        }()

        public static let defaultTimeFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return formatter
        }()

        public var isRange: Bool {
            switch self {
            case .dateRange, .timeRange: return true
            case .date, .time: return false
            }
        }

        public var isTime: Bool {
            switch self {
            case .time, .timeRange: return true
            case .date, .dateRange: return false
            }
        }
    }
}

