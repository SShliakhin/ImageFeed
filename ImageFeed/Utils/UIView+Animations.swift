//
//  UIView+Animations.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 26.12.2022.
//

import UIKit

extension UIView {
    func transform3DMakeRotation(
        degree: Double,
        x: CGFloat,
        y: CGFloat,
        z: CGFloat,
        duration: TimeInterval,
        delay: TimeInterval
    ) {
        let rotationAngle = CGFloat(degree * .pi / 180)
        let rotationTransform = CATransform3DMakeRotation(rotationAngle, x, y, z)
        layer.transform = rotationTransform

        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: .curveEaseInOut,
            animations: {
                self.layer.transform = CATransform3DIdentity
            }
        )
    }
}