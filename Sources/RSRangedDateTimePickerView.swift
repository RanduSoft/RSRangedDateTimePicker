//
//  RSRangedDateTimePickerView - SwiftUI
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import SwiftUI

public struct RSRangedDateTimePickerView: View {
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
        VStack {
            PickerView(style: style, config: config, selectedDate: $selectedDate, selectedRange: $selectedRange)
            
            Button {
                showSheet.toggle()
            } label: {
                Text("Save")
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .frame(height: 30)
            }.buttonStyle(.borderedProminent).padding(.horizontal, 24)
        }
        .padding(.top, 38).padding(.bottom, 20)
        .presentationDetents([.height(290)])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius()
    }
}

extension View {
    @ViewBuilder func presentationCornerRadius() -> some View {
        if #available(iOS 16.4, *) {
            self.presentationCornerRadius(18)
        } else {
            self
        }
    }
}

#Preview {
    RSRangedDateTimePickerView(style: .date())
}
