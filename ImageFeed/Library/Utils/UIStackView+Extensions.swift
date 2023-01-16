//
//  UIStackView+Extensions.swift
//  ImageFeed
//
//  Created by SERGEY SHLYAKHIN on 12.01.2023.
//

import UIKit

extension UIStackView {
    func arrangeStackView(
        subviews: [UIView],
        spacing: CGFloat = 0,
        axis: NSLayoutConstraint.Axis = .horizontal,
        distribution: UIStackView.Distribution = .fill,
        aligment: UIStackView.Alignment = .fill
    ) {
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = aligment
        
        subviews.forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            self.addArrangedSubview(item)
        }
    }
}
