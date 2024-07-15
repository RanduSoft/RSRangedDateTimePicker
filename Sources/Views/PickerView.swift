//
//  RSRangedDateTimePickerView
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import SwiftUI
import UIKit

public struct RSRangedDateTimePickerView: UIViewRepresentable {
    @State var style: RSRangedDateTimePickerView.Style
    @State var config: RSRangedDateTimePickerView.Config
    
    @Binding var selectedDate: Date
    @Binding var selectedRange: RSRangedDateTimePickerView.DateRange
    
    public init(style: RSRangedDateTimePickerView.Style, config: RSRangedDateTimePickerView.Config, selectedDate: Binding<Date>? = nil, selectedRange: Binding<RSRangedDateTimePickerView.DateRange>? = nil) {
        self.style = style
        self.config = config
        self._selectedDate = selectedDate ?? .constant(.now)
        self._selectedRange = selectedRange ?? .constant(RSRangedDateTimePickerView.DateRange(start: .now, end: .now))
    }
    
    public func makeCoordinator() -> RSRangedDateTimePickerView.Coordinator {
        return Coordinator(self)
    }
    
    public func makeUIView(context: UIViewRepresentableContext<RSRangedDateTimePickerView>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        
        context.coordinator.refreshDates()
        
        context.coordinator.selectRow(
            context.coordinator.row(date: selectedRange.start, component: 0),
            inComponent: 0, in: picker, animated: false)
        
        context.coordinator.selectRow(
            context.coordinator.row(date: selectedRange.end, component: 1),
            inComponent: 1, in: picker, animated: false)
        
        return picker
    }
    
    public func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<RSRangedDateTimePickerView>) {
        // not needed
    }
}

#Preview {
    RSRangedPickerDemoView()
}
