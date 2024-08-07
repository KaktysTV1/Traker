import Foundation
import UIKit

protocol AlertPresenterProtocol: AnyObject {
    func showAlert(model: AlertModel)
}

final class AlertPresenter: AlertPresenterProtocol {
    // MARK: - Properties:
    weak var delegate: UIViewController?

    // MARK: - Methods:
    init(delegate: UIViewController) {
        self.delegate = delegate
    }

    func showAlert(model: AlertModel) {
        let alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .actionSheet)

        let firstAction = UIAlertAction(
            title: model.firstButtonText,
            style: .destructive) { _ in
                model.firstCompletion()
            }
        let secondAction = UIAlertAction(
            title: model.secondButtonText,
            style: .cancel)

        alert.addAction(firstAction)
        alert.addAction(secondAction)
        delegate?.present(alert, animated: true)
    }
}
