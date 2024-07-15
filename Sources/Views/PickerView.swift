//
//  RSRangedDateTimePickerView
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import SwiftUI
import UIKit

public struct RSRangedDateTimePickerView: UIViewRepresentable {
    @State var style: Style
    @State var config: Config
    
    @Binding var selectedRange: DateRange
    
    public func makeCoordinator() -> RSRangedDateTimePickerView.Coordinator {
        return Coordinator(self)
    }
    
    public func makeUIView(context: UIViewRepresentableContext<RSRangedDateTimePickerView>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        
        context.coordinator.refreshDates()
        
        picker.selectRow(
            context.coordinator.row(date: selectedRange.start, component: 0),
            inComponent: 0, animated: false
        )
        picker.selectRow(
            context.coordinator.row(date: selectedRange.end, component: 1),
            inComponent: 1, animated: false
        )
        
        return picker
    }
    
    public func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<RSRangedDateTimePickerView>) {}
}

#Preview {
    RSRangedPickerDemoView()
}
