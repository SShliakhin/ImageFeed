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
