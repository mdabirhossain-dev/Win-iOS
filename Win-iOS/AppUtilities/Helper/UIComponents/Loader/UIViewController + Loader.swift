//
//
//  UIViewController + Loader.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - UIViewController + Loader
private var loaderKey: UInt8 = 0

extension UIViewController {
    
    /// Lazily created shared loader overlay for this view controller.
    private var loaderView: LoaderView {
        if let existing = objc_getAssociatedObject(self, &loaderKey) as? LoaderView {
            // If VC view got recreated, re-attach loader
            if existing.superview !== view {
                existing.removeFromSuperview()
                view.addSubview(existing)
                NSLayoutConstraint.activate([
                    existing.topAnchor.constraint(equalTo: view.topAnchor),
                    existing.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    existing.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    existing.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                ])
            }
            return existing
        }
        
        let loader = LoaderView(frame: .zero)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.isHidden = true
        
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.topAnchor.constraint(equalTo: view.topAnchor),
            loader.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loader.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        objc_setAssociatedObject(self, &loaderKey, loader, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return loader
    }
    
    /// Show / hide loader with optional retry callback.
    /// Use this from your VIPER View, Presenter calls this via view interface.
    func showLoader(_ state: LoaderState, retry: (() -> Void)? = nil) {
        let loader = loaderView
        loader.retryHandler = retry
        loader.setState(state)
        
        // If you use tableView/collectionView and want loader instead of content,
        // you can also hide them here if needed:
        // tableView.isHidden = (state != .hidden && state != .content)
    }
}
