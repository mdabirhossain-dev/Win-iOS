//
//
//  NavBarButton.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 9/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

/// Minimal configurable nav button (iOS 15+ using UIButton.Configuration)
final class NavBarButton: UIButton {
    enum Style {
        case icon(UIImage, UIImage.RenderingMode = .alwaysTemplate)
        case title(String)
        case titleIcon(String, UIImage, UIImage.RenderingMode = .alwaysTemplate)
    }

    // MARK: - Constants
    private struct Constants {
        static let height: CGFloat = 28
        static let cornerRadius: CGFloat = height / 2
        static let imageSize = CGSize(width: 16, height: 16)
        static let verticalPadding: CGFloat = 4
        static let horizontalPadding: CGFloat = 8
        static let imageTitleSpacing: CGFloat = 6
        static let textStyle: UIFont.TextStyle = .callout
        static let tintColor = UIColor.wcVelvet
    }

    // MARK: - Properties
    private var style: Style
    private var isBackButton: Bool

    private var baseFont: UIFont { UIFont.winFont(.semiBold, size: .extraSmall) }
    private var scaledFont: UIFont {
        UIFontMetrics(forTextStyle: Constants.textStyle).scaledFont(for: baseFont)
    }

    // MARK: - Initialization
    init(_ style: Style, accessibilityLabel: String? = nil, isBackButton: Bool = false) {
        self.style = style
        self.isBackButton = isBackButton
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: Constants.height).isActive = true

        configureLayer()
        self.accessibilityLabel = accessibilityLabel
        applyConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func configureLayer() {
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true
        layer.borderWidth = isBackButton ? 0 : 1
        layer.borderColor = Constants.tintColor.cgColor
    }

    private func applyConfiguration() {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(
            top: Constants.verticalPadding,
            leading: Constants.horizontalPadding,
            bottom: Constants.verticalPadding,
            trailing: Constants.horizontalPadding
        )
        config.baseForegroundColor = Constants.tintColor
        config.imagePadding = Constants.imageTitleSpacing
        config.imagePlacement = .leading
        config.titleAlignment = .leading

        switch style {
        case .icon(let image, let renderingMode):
            config.image = image.withRenderingMode(renderingMode)

        case .title(let title):
            config.attributedTitle = attributedTitle(for: title)

        case .titleIcon(let title, let image, let renderingMode):
            config.image = image.resized(to: Constants.imageSize).withRenderingMode(renderingMode)
            config.attributedTitle = attributedTitle(for: title)
        }

        configuration = config
        titleLabel?.adjustsFontForContentSizeCategory = true
    }

    private func attributedTitle(for text: String) -> AttributedString {
        var attributes = AttributeContainer()
        attributes.font = scaledFont
        attributes.foregroundColor = Constants.tintColor
        return AttributedString(text, attributes: attributes)
    }

    // MARK: - Public API
    func setTint(_ color: UIColor) {
        var updatedConfig = configuration
        updatedConfig?.baseForegroundColor = color
        configuration = updatedConfig
        layer.borderColor = color.cgColor
    }

    func updateStyle(_ newStyle: Style, isBackButton: Bool? = nil) {
        self.style = newStyle
        if let back = isBackButton {
            self.isBackButton = back
            layer.borderWidth = back ? 0 : 1
        }
        applyConfiguration()
    }

    // Rebuild on Dynamic Type change
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            applyConfiguration()
        }
    }
}







//final class NavBarButton: UIButton {
//    enum Style {
//        case icon(UIImage, UIImage.RenderingMode = .alwaysTemplate)
//        case title(String)
//        case titleIcon(String, UIImage, UIImage.RenderingMode = .alwaysTemplate)
//    }
//
//    init(_ style: Style, accessibility: String? = nil, isBackButton: Bool = false) {
//        super.init(frame: .zero)
//        translatesAutoresizingMaskIntoConstraints = false
//        self.titleLabel?.font = .winFont(.semiBold, size: .extraSmall)
//        heightAnchor.constraint(equalToConstant: 28).isActive = true
//        
//        guard #available(iOS 15, *) else { fatalError("iOS 15+") }
//        let verticalPadding: CGFloat = 4
//        let horizontalPadding: CGFloat = 8
//        
//        var config = UIButton.Configuration.plain()
//        config.contentInsets = NSDirectionalEdgeInsets(top: verticalPadding, leading: horizontalPadding, bottom: verticalPadding, trailing: horizontalPadding)
//        
//        switch style {
//        case .icon(let img, let renderingMode):
//            config.image = img.withRenderingMode(renderingMode)
//            config.imagePlacement = .leading
//        case .title(let title):
//            config.title = title
//        case .titleIcon(let title, let img, let renderingMode):
//            config.title = title
//            config.image = img.resized(to: CGSize(width: 16, height: 16)).withRenderingMode(renderingMode)
//            config.imagePlacement = .leading
//        }
//        
//        config.baseForegroundColor = .wcVelvet
//        config.titleLabel.font = .winFont(.semiBold, size: .extraSmall)
//        
//        // Rounded corners & optional border
//        
//        layer.cornerRadius = 14
//        clipsToBounds = true
//        
//        if !isBackButton {
//            layer.borderColor = UIColor.wcVelvet.cgColor
//            layer.borderWidth = 1
//            layer.masksToBounds = true
//        }
//        
//        configuration = config
//        accessibilityLabel = accessibility
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func setTint(_ color: UIColor) {
//        if #available(iOS 15, *) {
//            var config = configuration
//            config?.baseForegroundColor = color
//            configuration = config
//        } else {
//            tintColor = color
//        }
//    }
//}
