//
//
//  UIView + Additions.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/9/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit
import ObjectiveC

private var gradientLayerKey: UInt8 = 0

// MARK: - UIView Extensions (your code + removeGradient)
extension UIView {

    func addSubviews(_ views: [UIView]) {
        for view in views { addSubview(view) }
    }

    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false

        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }

    func centerXInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        if let superViewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superViewCenterXAnchor).isActive = true
        }
    }

    // Keeping your naming to avoid breaking existing project calls.
    func applyCornerRadious(_ radius: CGFloat, borderWidth: CGFloat = 0, borderColor: UIColor = .clear) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
    }

    func applyShadow() {
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.12
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.masksToBounds = false
    }

    // MARK: - Associated gradient layer
    private var reusableGradientLayer: CAGradientLayer? {
        get { objc_getAssociatedObject(self, &gradientLayerKey) as? CAGradientLayer }
        set { objc_setAssociatedObject(self, &gradientLayerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    // MARK: - Swizzle layoutSubviews once (your approach)
    private static let gradientSwizzleLayoutSubviewsOnce: Void = {
        let originalSelector = #selector(UIView.layoutSubviews)
        let swizzledSelector = #selector(UIView.gradientLayoutSubviews)

        guard
            let originalMethod = class_getInstanceMethod(UIView.self, originalSelector),
            let swizzledMethod = class_getInstanceMethod(UIView.self, swizzledSelector)
        else { return }

        method_exchangeImplementations(originalMethod, swizzledMethod)
    }()

    @objc private func gradientLayoutSubviews() {
        // Call original layoutSubviews (because methods are swapped)
        self.gradientLayoutSubviews()

        // Now adjust gradient frame if present
        if let gradientLayer = reusableGradientLayer {
            gradientLayer.frame = bounds
        }
    }

    // MARK: - Public API
    @discardableResult
    func applyGradient(
        colors: [UIColor],
        direction: GradientDirection = .vertical,
        locations: [NSNumber]? = nil,
        cornerRadius: CGFloat? = nil
    ) -> CAGradientLayer {

        // Ensure swizzling is done exactly once
        _ = UIView.gradientSwizzleLayoutSubviewsOnce

        let gradientLayer: CAGradientLayer

        if let existing = reusableGradientLayer {
            gradientLayer = existing
        } else {
            gradientLayer = CAGradientLayer()
            gradientLayer.masksToBounds = true
            layer.insertSublayer(gradientLayer, at: 0)
            reusableGradientLayer = gradientLayer
        }

        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations

        let points = direction.points
        gradientLayer.startPoint = points.start
        gradientLayer.endPoint = points.end

        gradientLayer.cornerRadius = cornerRadius ?? layer.cornerRadius

        return gradientLayer
    }

    /// ✅ Needed so you can switch from gradient -> solid cleanly.
    func removeGradient() {
        reusableGradientLayer?.removeFromSuperlayer()
        reusableGradientLayer = nil
    }
}

// Uneven
extension UIView {
    func applyCornerRadius(_ radius: CGFloat, corners: CACornerMask) {
        layer.cornerRadius = radius
        layer.maskedCorners = corners
        layer.masksToBounds = true
    }
}
