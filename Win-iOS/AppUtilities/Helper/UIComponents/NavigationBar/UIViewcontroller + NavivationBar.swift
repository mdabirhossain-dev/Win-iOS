//
//
//  UIViewcontroller + NavigationBar.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 9/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - Hides iOS26 Liquid Glass effects
extension UIBarButtonItem {
    @discardableResult
    func hideLiquidGlassEffect() -> UIBarButtonItem {
        if #available(iOS 26.0, *) {
            self.hidesSharedBackground = true
        }
        return self
    }
}

// Delegate protocol for nav bar events
public protocol NavigationBarDelegate: AnyObject {
    func navBarDidTapBack(in vc: UIViewController)
    func navBarDidTapProject(in vc: UIViewController)
    func navBar(_ vc: UIViewController, didTapRightButtonAt index: Int)
}
public extension NavigationBarDelegate {
    // default no-op implementations so methods are effectively optional
    func navBarDidTapBack(in vc: UIViewController) {}
    func navBarDidTapProject(in vc: UIViewController) {}
    func navBar(_ vc: UIViewController, didTapRightButtonAt index: Int) {}
}

public extension UIViewController {
    /// Configure native navigation bar. Delegate receives events.
    /// rightButtons order: left-to-right.
    func setupNavigationBar(
        projectIcon: (UIImage, UIImage.RenderingMode) = (UIImage(), .alwaysOriginal),
        projectName: String = "",
        rightButtons: [NavigationBarButtonConfig] = [],
        isBackButton: Bool = false,
        delegate: NavigationBarDelegate? = nil
    ) {
        // appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = false

        // left: project view (icon + optional name)
        let iconView = UIImageView(image: projectIcon.0.withRenderingMode(projectIcon.1))
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .wcVelvet
        iconView.widthAnchor.constraint(equalToConstant: 76).isActive = true
//        iconView.heightAnchor.constraint(equalToConstant: 28).isActive = true
//        iconView.leadingAnchor.constraint(equalTo: iconView.leadingAnchor).isActive = true

        let stack = UIStackView(arrangedSubviews: [iconView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center

        if projectName.isNotEmpty {
            let label = UILabel()
            label.text = projectName
            label.font = .winFont(.semiBold, size: .extraSmall)
            label.textColor = .label
            stack.addArrangedSubview(label)
        }

        let projectButton = UIButton(type: .system)
        projectButton.translatesAutoresizingMaskIntoConstraints = false
        projectButton.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: projectButton.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: projectButton.centerYAnchor),
            stack.topAnchor.constraint(equalTo: projectButton.topAnchor),
            stack.bottomAnchor.constraint(equalTo: projectButton.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: projectButton.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: projectButton.trailingAnchor),
            projectButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        if let d = delegate {
            projectButton.addAction(UIAction { [weak d, weak self] _ in
                guard let s = self else { return }
                d?.navBarDidTapProject(in: s)
            }, for: .touchUpInside)
        }

        // left items: optional back (chevron only actionable) + project
        var leftItems: [UIBarButtonItem] = []
        if isBackButton {
            // chevron button: actionable
            let chevron = UIImage(systemName: "chevron.left")!
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: 20, weight: .regular))

            let chevronBtn = NavBarButton(.icon(chevron), isBackButton: isBackButton)
            chevronBtn.addAction(UIAction { [weak delegate, weak self] _ in
                guard let self = self else { return }
                delegate?.navBarDidTapBack(in: self)
            }, for: .touchUpInside)
            chevronBtn.setTint(.wcVelvet)

            // title label: non-actionable text shown to the right of the chevron
            let backLabel = UILabel()
            backLabel.text = viewControllerTitle
            backLabel.font = .winFont(.bold, size: .medium)
            backLabel.textColor = .wcVelvet
            backLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

            // container: chevron (button) + label (no action)
            let backContainer = UIStackView(arrangedSubviews: [chevronBtn, backLabel])
            backContainer.alignment = .center
            
            leftItems.append(UIBarButtonItem(customView: backContainer))//.hideLiquidGlassEffect())
        }

        leftItems.append(UIBarButtonItem(customView: projectButton))//.hideLiquidGlassEffect())
        navigationItem.leftBarButtonItems = leftItems

        // right items: reversed to keep left-to-right order
        navigationItem.rightBarButtonItems = rightButtons.reversed().enumerated().map { (offset, config) in
            let index = rightButtons.count - 1 - offset
            let style: NavBarButton.Style

            if let img = config.image, let text = config.title, !text.isEmpty {
                style = .titleIcon(text, img, config.renderingMode!)
            } else if let img = config.image {
                style = .icon(img, config.renderingMode!)
            } else {
                style = .title(config.title ?? "")
            }

            let button = NavBarButton(style)
            button.addAction(UIAction { [weak delegate, weak self] _ in
                guard let viewController = self else { return }
                delegate?.navBar(viewController, didTapRightButtonAt: index)
            }, for: .touchUpInside)
            button.setTint(.wcVelvet)
            
            return UIBarButtonItem(customView: button)
        }
    }
}
