//
//  ILoadWithIndicator.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 14.02.2023.
//

import UIKit

protocol ILoadWithIndicator: AnyObject {
	var activityIndicator: UIActivityIndicatorView { get }
	
	func startIndicator()
	func stopIndicator()
}

extension ILoadWithIndicator {
	func startIndicator() {
		self.activityIndicator.startAnimating()
	}
	
	func stopIndicator() {
		self.activityIndicator.startAnimating()
	}
}

// ProgressHUD на GitHub: https://github.com/relatedcode/ProgressHUD
import ProgressHUD

protocol ILoadWithProgressHUD: AnyObject {
	func startIndicator()
	func stopIndicator()
}

extension ILoadWithProgressHUD {
	func startIndicator() {
		ProgressHUD.show()
	}
	
	func stopIndicator() {
		ProgressHUD.dismiss()
	}
}
