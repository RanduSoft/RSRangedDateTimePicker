//
//  RSRangedDateTimePickerViewController - UIKit
//
//  Created by Radu Ursache - RanduSoft
//  Version: 1.0
//

import UIKit
import SwiftUI

public class RSRangedDateTimePickerViewController: UIViewController {
    
    private var style: PickerView.Style
    private var config: PickerView.Config?
    
    private var selectedDate: Date
    private var selectedRange: PickerView.DateRange
    
    public var onDateSelected: ((Date) -> Void)?
    public var onRangeSelected: ((PickerView.DateRange) -> Void)?
    public var onDismiss: (() -> Void)?
    
    private var hostingController: UIHostingController<RSRangedDateTimePickerSheetView>?
    
    public init(style: PickerView.Style, config: PickerView.Config? = nil, initialDate: Date = .now, initialRange: PickerView.DateRange = PickerView.DateRange(start: .now, end: .now)) {
        self.style = style
        self.config = config
        self.selectedDate = initialDate
        self.selectedRange = initialRange
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .clear
        
        let swiftUIView = RSRangedDateTimePickerSheetView(
            style: style,
            config: config,
            selectedDate: Binding(
                get: { self.selectedDate },
                set: { newValue in
                    self.selectedDate = newValue
                    self.onDateSelected?(newValue)
                }
            ),
            selectedRange: Binding(
                get: { self.selectedRange },
                set: { newValue in
                    self.selectedRange = newValue
                    self.onRangeSelected?(newValue)
                }
            ),
            onDismiss: { [weak self] in
                self?.onDismiss?()
            }
        )
        
        hostingController = UIHostingController(rootView: swiftUIView)
        guard let hostingController else {
            return
        }
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.backgroundColor = .clear
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.didMove(toParent: self)
    }
}

public extension RSRangedDateTimePickerViewController {
    static func show(on viewController: UIViewController, style: PickerView.Style, config: PickerView.Config? = nil, initialDate: Date = .now, initialRange: PickerView.DateRange = PickerView.DateRange(start: .now, end: .now), onDateSelected: ((Date) -> Void)? = nil, onRangeSelected: ((PickerView.DateRange) -> Void)? = nil, onDismiss: (() -> Void)? = nil) {
        let pickerVC = RSRangedDateTimePickerViewController(
            style: style,
            config: config,
            initialDate: initialDate,
            initialRange: initialRange
        )
        
        pickerVC.onDateSelected = onDateSelected
        pickerVC.onRangeSelected = onRangeSelected
        pickerVC.onDismiss = onDismiss
        
        pickerVC.modalPresentationStyle = .overCurrentContext
        viewController.present(pickerVC, animated: false, completion: nil)
    }
}

