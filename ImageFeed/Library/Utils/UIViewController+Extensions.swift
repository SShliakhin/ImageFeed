import UIKit

protocol IBaseViewController: AnyObject {
	func showErrorDialog(with message: String)
}

extension UIViewController: IBaseViewController {
	
	/// Показывает простой алерт с описанием ошибки
	/// - Parameter message: описание ошибки
	func showErrorDialog(with message: String) {
		let alert = UIAlertController(
			title: "Warning",
			message: message,
			preferredStyle: .alert
		)
		alert.addAction(
			.init(
				title: "OK",
				style: .default
			)
		)
		self.present(alert, animated: true)
	}
}
