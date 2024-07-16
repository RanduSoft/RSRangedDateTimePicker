//
//  RSRangedDateTimePickerView - DateRange
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import Foundation

extension PickerView {
    public struct DateRange: Equatable {
        public let start: Date
        public let end: Date
        
        public init(start: Date, end: Date) {
            self.start = start
            self.end = end
        }
    }
}
