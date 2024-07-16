//
//  DemoView
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import SwiftUI

struct DemoView: View {
    @State private var dateRange = PickerView.DateRange(
        start: Date(),
        end: Date()
    )
    
    @State private var timeRange = PickerView.DateRange(
        start: Date(),
        end: Date()
    )
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Text("Time").bold()
                PickerView(style: .timeRange(), config: .time, selectedRange: self.$timeRange)
                    .frame(height: 200)
                
                Text("Selection").italic()
                HStack(spacing: 60) {
                    Text(timeRange.start, style: .time)
                    Text(timeRange.end, style: .time)
                }
            }
            
            Divider()
            
            VStack(spacing: 12) {
                Text("Date").bold()
                PickerView(style: .dateRange(), config: .date, selectedRange: self.$dateRange)
                    .frame(height: 200)
                
                Text("Selection").italic()
                HStack(spacing: 60) {
                    Text(dateRange.start, style: .date)
                    Text(dateRange.end, style: .date)
                }
            }
            
            Spacer()
        }.onChange(of: timeRange) { newValue in
            print("Time range changed to \(newValue.start) - \(newValue.end)")
        }.onChange(of: dateRange) { newValue in
            print("Date range changed to \(newValue.start) - \(newValue.end)")
        }.frame(maxHeight: .infinity)
    }
}

#Preview {
    DemoView()
}
