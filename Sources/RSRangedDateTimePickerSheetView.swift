//
//  RSRangedDateTimePickerSheetView - SwiftUI
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import SwiftUI

public struct RSRangedDateTimePickerSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var style: PickerView.Style
    @State var config: PickerView.Config?
    
    @Binding var selectedDate: Date
    @Binding var selectedRange: PickerView.DateRange
    
    @State private var showSheet: Bool = true
    private let onDismiss: (() -> Void)?
    
    public init(style: PickerView.Style, config: PickerView.Config? = nil, selectedDate: Binding<Date>? = nil, selectedRange: Binding<PickerView.DateRange>? = nil, onDismiss: (() -> Void)? = nil) {
        self.style = style
        self.config = config
        self._selectedDate = selectedDate ?? .constant(.now)
        self._selectedRange = selectedRange ?? .constant(PickerView.DateRange(start: .now, end: .now))
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ZStack {
            Spacer()
        }.sheet(isPresented: $showSheet, onDismiss: {
            onDismiss?()
        }, content: {
            RSRangedDateTimePickerView(style: style, config: config, selectedDate: $selectedDate, selectedRange: $selectedRange, onDismiss: onDismiss)
        }).onChange(of: showSheet) { newValue in
            if newValue == false {
                dismiss()
            }
        }
    }
}


#Preview {
    RSRangedDateTimePickerView(style: .dateRange(), config: .date, selectedDate: .constant(.now))
}
