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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        frame: CGRect,
        image: UIImage,
        minZoomScale: CGFloat? = nil,
        maxZoomScale: CGFloat? = nil
    ) {
        self.frame = frame
        detailedImageView.removeFromSuperview()

        detailedImageView = UIImageView(image: image)
        addSubview(detailedImageView)
        
        let zoomFactors = getZoomFactors(imageSize: image.size)
        
        if let minZoomScale = minZoomScale,
           let maxZoomScale = maxZoomScale {
            minimumZoomScale = minZoomScale
            maximumZoomScale = maxZoomScale
        } else {
            minimumZoomScale = zoomFactors.hScale
            maximumZoomScale = min(zoomFactors.vScale, zoomFactors.hScale * 2)
        }
        
        let scale = min(maximumZoomScale, max(minimumZoomScale, max(zoomFactors.hScale, zoomFactors.vScale)))
        setZoomScale(scale, animated: false)
        
        let containerSize = bounds.size
        scrollRectToVisible(
            CGRect(
                x: abs(contentSize.width - containerSize.width) / 2,
                y: abs(contentSize.height - containerSize.height) / 2,
                width: min(contentSize.width, containerSize.width),
                height: min(contentSize.height, containerSize.height)
            ),
            animated: false
        )
        
        detailedImageView.addGestureRecognizer(zoomingTap)
        detailedImageView.isUserInteractionEnabled = true
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        centerImageView()
    }
    
    private func getZoomFactors(imageSize: CGSize) -> (hScale: CGFloat, vScale: CGFloat) {
        let containerSize = bounds.size
        let hScale = containerSize.width / imageSize.width
        let vScale = containerSize.height / imageSize.height
        return (hScale, vScale)
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
