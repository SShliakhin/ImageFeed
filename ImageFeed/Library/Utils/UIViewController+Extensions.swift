import UIKit

protocol IViewControllerWithErrorDialog: AnyObject {
	func showErrorDialog(with message: String, completion: (() -> Void)?)
	func showErrorDialog(completion: (() -> Void)?)
}

extension IViewControllerWithErrorDialog {
	func showErrorDialog(with message: String, completion: (() -> Void)? = nil) {
		showErrorDialog(with: message, completion: completion)
	}
	func showErrorDialog(completion: (() -> Void)? = nil) {
		showErrorDialog(completion: completion)
	}
}

struct AlertModel {
	let title: String
	let message: String
	let buttonText: String
	let cancelButtonText: String?

	let completion: () -> Void
}

protocol IViewControllerWithAlertDialog: AnyObject {
	func showAlertDialog(_ model: AlertModel)
}

// MARK: - IViewControllerWithErrorDialog

extension UIViewController: IViewControllerWithErrorDialog {
	func showErrorDialog(completion: (() -> Void)? = nil) {
		let alert = UIAlertController(
			title: "Что-то пошло не так(",
			message: "Не удалось войти в систему",
			preferredStyle: .alert
		)
		alert.addAction(
			.init(
				title: "OK",
				style: .default
			) { _ in
				completion?()
			}
		)
		self.present(alert, animated: true)
	}

	func showErrorDialog(with message: String, completion: (() -> Void)? = nil) {
		let alert = UIAlertController(
			title: "Warning",
			message: message,
			preferredStyle: .alert
		)
		alert.addAction(
			.init(
				title: "OK",
				style: .default
			) { _ in
				completion?()
			}
		)

		self.present(alert, animated: true)
	}
}

// MARK: - IViewControllerWithAlertDialog

extension UIViewController: IViewControllerWithAlertDialog {
	func showAlertDialog(_ model: AlertModel) {
		let alert = UIAlertController(
			title: model.title,
			message: model.message,
			preferredStyle: .alert
		)
		alert.addAction(
			.init(
				title: model.buttonText,
				style: .default
			) { _ in
				model.completion()
			}
		)
		if let cancelButtonText = model.cancelButtonText {
			alert.addAction(
				.init(
					title: cancelButtonText,
					style: .cancel
				)
			)
		}
		self.present(alert, animated: true)
	}
}
