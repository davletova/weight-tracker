import UIKit
import Foundation
import Toast

class ToastPresenter {
    weak private var parentView: UIView?
    private lazy var toastConfig = ToastConfiguration(
        direction: .bottom,
        dismissBy: [.time(time: 2.0), .swipe(direction: .natural), .longPress],
        attachTo: parentView
    )
    private lazy var toastViewConfig = ToastViewConfiguration(
        minHeight: 52,
        minWidth: (parentView?.bounds.width ?? 280) - 32,
        darkBackgroundColor: .getAppColors(.appToastBackground),
        lightBackgroundColor: .getAppColors(.appToastBackground),
        cornerRadius: 12.0
    )
    
    init(parentView: UIView) {
        self.parentView = parentView
    }
    
    func show(_ message: String) {
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.getAppColors(.appGeneralBackground)
        ]
        let attributedString  = NSMutableAttributedString(string: message, attributes: attributes)
        
        Toast.text(attributedString, viewConfig: toastViewConfig, config: toastConfig).show()
    }
}
