import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void 
}

final class AlertPresenter {
    private weak var delegate: UIViewController?
    
    init(delegate: UIViewController) {
        self.delegate = delegate
    }
    
    func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }
        
        alert.addAction(action)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
