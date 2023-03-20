//
//  GradientKFIndicator.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 18.03.2023.
//

import Kingfisher
import UIKit

final class GradientKFIndicator {
	let gradientView: GradientView
	let changeAnimation: CABasicAnimation
	var gradientLayer: CAGradientLayer {
		gradientView.getLayer()
	}

	init(gradientLayer: CAGradientLayer, changeAnimation: CABasicAnimation) {
		let gradientView = GradientView()
		gradientView.configure(from: gradientLayer)
		self.gradientView = gradientView
		self.changeAnimation = changeAnimation
	}
}

// MARK: - Indicator

extension GradientKFIndicator: Indicator {
	var view: UIView {
		return gradientView
	}

	func startAnimatingView() {
		gradientLayer.add(changeAnimation, forKey: "locationsChange")
		view.isHidden = false
	}

	func stopAnimatingView() {
		gradientLayer.removeAllAnimations()
		view.isHidden = true
	}
}
