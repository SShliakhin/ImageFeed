//
//  FullScreenImageScrollView.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 15.01.2023.
//

import UIKit

final class FullScreenImageScrollView: UIScrollView {

    private var detailedImageView = UIImageView()
    private lazy var zoomingTap: UITapGestureRecognizer = {
        let zoomingTap = UITapGestureRecognizer(target: self, action: #selector(handleZoomingTap))
        zoomingTap.numberOfTapsRequired = 2
        return zoomingTap
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.decelerationRate = UIScrollView.DecelerationRate.fast
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        image: UIImage,
        minimumZoomScale: CGFloat? = nil,
        maximumZoomScale: CGFloat? = nil
    ) {
        detailedImageView.removeFromSuperview()

        detailedImageView = UIImageView(image: image)
        addSubview(detailedImageView)
        
        if let minimumZoomScale = minimumZoomScale,
           let maximumZoomScale = maximumZoomScale {
            self.minimumZoomScale = minimumZoomScale
            self.maximumZoomScale = maximumZoomScale
        } else {
            rescale(imageSize: image.size)
        }
        
        detailedImageView.addGestureRecognizer(zoomingTap)
        detailedImageView.isUserInteractionEnabled = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        centerImageView()
    }
    
    private func rescale(imageSize: CGSize) {
        let containerSize = bounds.size
        
        let hScale = containerSize.width / imageSize.width
        let vScale = containerSize.height / imageSize.height
        
        minimumZoomScale = hScale
        maximumZoomScale = min(vScale, hScale * 2)
        zoomScale = hScale
    }

    private func centerImageView() {
        let containerSize = bounds.size
        var frameToCenter = detailedImageView.frame

        if frameToCenter.size.width < containerSize.width {
            frameToCenter.origin.x = (containerSize.width - frameToCenter.size.width) / 2
        } else {
            frameToCenter.origin.x = 0
        }

        if frameToCenter.size.height < containerSize.height {
            frameToCenter.origin.y = (containerSize.height - frameToCenter.size.height) / 2
        } else {
            frameToCenter.origin.y = 0
        }

        detailedImageView.frame = frameToCenter
    }
}

// MARK: - UIScrollViewDelegate
extension FullScreenImageScrollView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return detailedImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImageView()
    }
}

// MARK: - Gesture
private extension FullScreenImageScrollView {
    @objc func handleZoomingTap(sender: UITapGestureRecognizer) {
        let location = sender.location(in: sender.view)
        zoom(point: location, animated: true)
    }

    func zoom(point: CGPoint, animated: Bool) {
        if minimumZoomScale == maximumZoomScale
            && minimumZoomScale > 1 {
            return
        }
        let finalScale = zoomScale == minimumZoomScale
        ? maximumZoomScale
        : minimumZoomScale
        
        let zoomRect = zoomRect(scale: finalScale, center: point)
        zoom(to: zoomRect, animated: animated)
    }

    func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        let containerSize = bounds.size
        zoomRect.size.width = containerSize.width / scale
        zoomRect.size.height = containerSize.height / scale
        zoomRect.origin.x = center.x - (zoomRect.size.width / 2)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2)
        return zoomRect
    }
}
