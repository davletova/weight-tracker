import Foundation
import UIKit

struct AlertModel {
    var style: UIAlertController.Style
    var title: String
    var message: String?
    var actions: [String: () -> Void]? = nil
}

final class AlertPresenter {
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController?) {
        self.delegate = delegate
    }
    
    func show(result: AlertModel) {
        var actions = [
            UIAlertAction(
                title: "Закрыть",
                style: .cancel
            ) { _ in }
        ]
        
        if let actionsDict = result.actions {
            for (buttonTitle, action) in actionsDict {
                actions.append(
                    UIAlertAction(
                        title: buttonTitle,
                        style: .default,
                        handler: { _ in action() }
                    )
                )
            }
        }
        
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: result.style)
        
        for action in actions {
            alert.addAction(action)
        }
        
        DispatchQueue.main.async {
            self.delegate?.present(alert, animated: true, completion: nil)
        }
    }
}
