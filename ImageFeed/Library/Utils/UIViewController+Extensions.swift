import UIKit

protocol IBaseViewController: AnyObject {
	func showErrorDialog(with message: String)
	func showErrorDialog()
}

extension UIViewController: IBaseViewController {
	/// Показывает простой алерт с заложенным описанием ошибки
	func showErrorDialog() {
		let alert = UIAlertController(
			title: "Что-то пошло не так(",
			message: "Не удалось войти в систему",
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
