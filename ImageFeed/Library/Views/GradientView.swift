import UIKit

final class GradientView: UIView {
	
	private lazy var gradientLayer = CAGradientLayer()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		layer.insertSublayer(gradientLayer, at: 0)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		gradientLayer.frame = bounds
	}

	func configure(from layer: CAGradientLayer) {
		gradientLayer.colors = layer.colors
		gradientLayer.locations = layer.locations
		gradientLayer.startPoint = layer.startPoint
		gradientLayer.endPoint = layer.endPoint
	}
	func getLayer() -> CAGradientLayer {
		gradientLayer
	}
}
