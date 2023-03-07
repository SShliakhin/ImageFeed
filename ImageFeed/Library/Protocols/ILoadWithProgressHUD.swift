//
//  ILoadWithProgressHUD.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 14.02.2023.
//

import UIKit
import ProgressHUD

protocol ILoadWithProgressHUD: AnyObject {
	func startIndicator()
	func stopIndicator()
}

extension ILoadWithProgressHUD {
	var window: UIWindow? {
		return UIApplication.shared.windows.first
	}
	
	func startIndicator() {
		window?.isUserInteractionEnabled = false
		ProgressHUD.show()
	}
	
	func stopIndicator() {
		window?.isUserInteractionEnabled = true
		ProgressHUD.dismiss()
	}
}
