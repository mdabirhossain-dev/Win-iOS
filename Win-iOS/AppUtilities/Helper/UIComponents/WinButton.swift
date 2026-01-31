//
//
//  WinButton.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 25/9/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit


// MARK: - WinButton (solid OR gradient background using YOUR gradient)
final class WinButton: UIButton {

    enum BackgroundStyle {
        case solid(UIColor)
        case gradient(colors: [UIColor],
                      direction: GradientDirection = .vertical,
                      cornerRadius: CGFloat? = nil,
                      locations: [NSNumber]? = nil)
    }

    private let defaultHeight: CGFloat = 44
    private let defaultCornerRadiusFactor: CGFloat = 0.5

    private let bgView = UIView()
    private var heightConstraint: NSLayoutConstraint?
    private var style: BackgroundStyle = .solid(.clear)

    // MARK: - Init
    init(height: CGFloat? = nil,
         cornerRadius: CGFloat? = nil,
         textColor: UIColor? = nil,
         background: BackgroundStyle = .solid(.clear)) {

        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        setupBackgroundView()

        // Height constraint (AutoLayout-friendly)
        let h = height ?? defaultHeight
        heightConstraint = heightAnchor.constraint(equalToConstant: h)
        heightConstraint?.isActive = true

        // Rounded corners should clip ONLY background, not content (your star)
        let r = cornerRadius ?? (h * defaultCornerRadiusFactor)
        layer.cornerCurve = .continuous
        layer.cornerRadius = r
        clipsToBounds = false

        bgView.layer.cornerCurve = .continuous
        bgView.layer.cornerRadius = r
        bgView.clipsToBounds = true

        // Title styling
        setTitleColor(textColor ?? .white, for: .normal)
        titleLabel?.textAlignment = .center
        // titleLabel?.font = .winFont(.semiBold, size: .medium)

        // Default alignments (adjust if you need)
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center

        setBackgroundStyle(background)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        translatesAutoresizingMaskIntoConstraints = false
        setupBackgroundView()
    }

    private func setupBackgroundView() {
        bgView.isUserInteractionEnabled = false
        bgView.translatesAutoresizingMaskIntoConstraints = false

        // IMPORTANT: put bgView behind everything
        insertSubview(bgView, at: 0)

        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: topAnchor),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Keep bg rounded in sync with button
        bgView.layer.cornerRadius = layer.cornerRadius

        // Make sure content stays on top
        if let iv = imageView { bringSubviewToFront(iv) }
        if let tl = titleLabel { bringSubviewToFront(tl) }

        // Re-apply to sync cornerRadius changes (your applyGradient keeps frame synced via swizzle)
        applyStyle()
    }

    // MARK: - Public API
    func setBackgroundStyle(_ style: BackgroundStyle) {
        self.style = style
        applyStyle()
    }

    func setSolidBackground(_ color: UIColor) {
        setBackgroundStyle(.solid(color))
    }

    func setGradientBackground(colors: [UIColor],
                               direction: GradientDirection = .vertical,
                               cornerRadius: CGFloat? = nil,
                               locations: [NSNumber]? = nil) {
        setBackgroundStyle(.gradient(colors: colors,
                                     direction: direction,
                                     cornerRadius: cornerRadius,
                                     locations: locations))
    }

    func setHeight(_ height: CGFloat, autoCornerRadius: Bool = true) {
        heightConstraint?.constant = height
        if autoCornerRadius {
            let r = height * defaultCornerRadiusFactor
            layer.cornerRadius = r
            bgView.layer.cornerRadius = r
        }
        setNeedsLayout()
        layoutIfNeeded()
    }

    // MARK: - Internal
    private func applyStyle() {
        switch style {
        case .solid(let color):
            bgView.removeGradient()
            bgView.backgroundColor = color

        case .gradient(colors: let colors, direction: let direction, cornerRadius: let cornerRadius, locations: let locations):
            bgView.backgroundColor = .clear
            bgView.applyGradient(
                colors: colors,
                direction: direction,
                locations: locations,
                cornerRadius: cornerRadius ?? layer.cornerRadius
            )
        }
    }
}

//class WinButton: UIButton {
//
//    // Default values
//    private let defaultHeight: CGFloat = 44
//    private let defaultCornerRadiusFactor: CGFloat = 0.5  // Corner radius will be half the height
//
//    // Initializer for programmatically creating the button
//    init(frame: CGRect = .zero, height: CGFloat? = nil, cornerRadius: CGFloat? = nil, textColor: UIColor? = nil, fill: BackgroundStyle = .solid(.wcVelvet)) {
//        super.init(frame: frame)
//
//        // Set default height and adjust button's frame
//        let buttonHeight = height ?? defaultHeight
//        self.frame.size.height = buttonHeight
//        self.layer.cornerRadius = cornerRadius ?? (buttonHeight * defaultCornerRadiusFactor)
//
//        // Set default button properties (background color, text color)
//        self.setTitleColor(textColor ?? .white, for: .normal)
//
//        switch fill {
//        case .solid(let color):
//            self.backgroundColor = backgroundColor ?? color
//        case .gradient(let colors, let direction, let cornerRadius, let locations):
//            applyGradient(colors: [.red, .green], cornerRadius: 50)
//        }
//
//        // Adjust the title to be centered
//        self.titleLabel?.textAlignment = .center
//        self.titleLabel?.font = .winFont(.semiBold, size: .medium)
//        self.translatesAutoresizingMaskIntoConstraints = false
//
//        // Automatically fill the width if not explicitly set
//        fillSuperviewWidthIfNeeded()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//
//    // This method ensures that the button fills the width of its superview if no explicit width is provided
//    private func fillSuperviewWidthIfNeeded() {
//        if self.frame.width == 0 {
//            // If width is not provided, fill the superview's width
//            guard let superview = self.superview else { return }
//            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
//            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
//        } else {
//            // If width is explicitly set, no need to adjust
//            self.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
//        }
//    }
//
//    // Method to change the background color dynamically
//    func setDynamicBackgroundColor(_ color: UIColor) {
//        self.backgroundColor = color
//    }
//}
