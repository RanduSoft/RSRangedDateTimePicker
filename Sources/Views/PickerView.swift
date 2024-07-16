//
//  PickerView
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import SwiftUI
import UIKit

public struct PickerView: UIViewRepresentable {
    @State var style: PickerView.Style
    @State var config: PickerView.Config
    
    @Binding var selectedDate: Date
    @Binding var selectedRange: PickerView.DateRange
    
    public init(style: PickerView.Style, config: PickerView.Config? = nil, selectedDate: Binding<Date>? = nil, selectedRange: Binding<PickerView.DateRange>? = nil) {
        self.style = style
        if let config {
            self.config = config
        } else {
            switch style {
                case .date, .dateRange:
                    self.config = .date
                case .time, .timeRange:
                    self.config = .time
            }
        }
        
        self._selectedDate = selectedDate ?? .constant(.now)
        self._selectedRange = selectedRange ?? .constant(PickerView.DateRange(start: .now, end: .now))
    }
    
    public func makeCoordinator() -> PickerView.Coordinator {
        return Coordinator(self)
    }
    
    public func makeUIView(context: UIViewRepresentableContext<PickerView>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        
        context.coordinator.refreshDates()
        
        switch style {
            case .date, .time:
                context.coordinator.selectRow(
                    context.coordinator.row(date: selectedDate, component: 0),
                    inComponent: 0, in: picker, animated: false)
            case .dateRange, .timeRange:
                context.coordinator.selectRow(
                    context.coordinator.row(date: selectedRange.start, component: 0),
                    inComponent: 0, in: picker, animated: false)
                
                context.coordinator.selectRow(
                    context.coordinator.row(date: selectedRange.end, component: 1),
                    inComponent: 1, in: picker, animated: false)
        }
        
        return picker
    }
    
    public func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<PickerView>) {
        // not needed
    }
}

#Preview {
    DemoView()
}
