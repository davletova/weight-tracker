import Foundation
import UIKit

final class AlertPresenter {
    
    weak var viewController: UIViewController?
    
    init(delegate: UIViewController? = nil) {
        self.viewController = delegate
    }
    
    func show(result: AlertModel) {
        let alert = UIAlertController(title: result.title, message: result.message, preferredStyle: result.style)
        
        for action in result.actions {
            alert.addAction(action)
        }
        DispatchQueue.main.async {
            self.viewController?.present(alert, animated: true, completion: nil)
        }
    }
}

struct AlertModel {
    var style: UIAlertController.Style
    var title: String
    var message: String?
    var actions: [UIAlertAction]
}
