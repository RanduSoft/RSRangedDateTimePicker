//
//  RSRangedDateTimePickerView - DateRange
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import Foundation

extension RSRangedDateTimePickerView {
    public struct DateRange: Equatable {
        let start: Date
        let end: Date
        
        public init(start: Date, end: Date) {
            self.start = start
            self.end = end
        }
    }
}
