//
//
//  KeyboardAvoider.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 6/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//

import UIKit

final class KeyboardAvoider {

    static let shared = KeyboardAvoider()

    private weak var activeVC: UIViewController?
    private var originalBottomInset: CGFloat = 0

    private init() {}

    func start() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(_ note: Notification) {
        guard
            let keyboardFrame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let window = UIApplication.shared.keyWindow,
            let responder = window.findFirstResponder(),
            let vc = responder.findViewController()
        else { return }

        activeVC = vc

        let responderFrame = responder.convert(responder.bounds, to: window)
        let overlap = responderFrame.maxY - keyboardFrame.minY + 12

        guard overlap > 0 else { return }

        if originalBottomInset == 0 {
            originalBottomInset = vc.additionalSafeAreaInsets.bottom
        }

        UIView.animate(withDuration: 0.25) {
            vc.additionalSafeAreaInsets.bottom = overlap
            vc.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide() {
        guard let vc = activeVC else { return }

        UIView.animate(withDuration: 0.25) {
            vc.additionalSafeAreaInsets.bottom = self.originalBottomInset
            vc.view.layoutIfNeeded()
        }

        originalBottomInset = 0
    }
}


private extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}

private extension UIView {
    func findFirstResponder() -> UIView? {
        if isFirstResponder { return self }
        for subview in subviews {
            if let r = subview.findFirstResponder() {
                return r
            }
        }
        return nil
    }
}

private extension UIView {
    func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            responder = responder?.next
            if let vc = responder as? UIViewController {
                return vc
            }
        }
        return nil
    }
}

