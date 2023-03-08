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
	
	func configure(
		colors: [CGColor],
		locations: [NSNumber]?,
		startPoint: CGPoint?,
		endPoint: CGPoint?
	) {
		gradientLayer.colors = colors
		gradientLayer.locations = locations
		
		guard
			let startPoint = startPoint,
			let endPoint = endPoint
		else { return }
		gradientLayer.startPoint = startPoint
		gradientLayer.endPoint = endPoint
	}
	
	override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		gradientLayer.frame = bounds
	}
}
