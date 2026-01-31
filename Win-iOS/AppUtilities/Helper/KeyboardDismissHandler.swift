//
//
//  KeyboardDismissHandler.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 23/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//



import UIKit
import ObjectiveC

private var _keyboardDismissHandlerKey: UInt8 = 0

private final class KeyboardDismissHandler: NSObject, UIGestureRecognizerDelegate {
    weak var hostView: UIView?
    private let ignoredViews: [WeakView]

    init(hostView: UIView, ignored: [UIView]) {
        self.hostView = hostView
        self.ignoredViews = ignored.map(WeakView.init)
        super.init()
    }

    @objc func handleTap() {
        hostView?.endEditing(true)
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let touchedView = touch.view else { return true }

        // Ignore taps inside any text input (textfield/textview or their subviews)
        if touchedView.closestSuperview(of: UITextField.self) != nil { return false }
        if touchedView.closestSuperview(of: UITextView.self) != nil { return false }

        // Optional: ignore specific views (e.g., a map, slider area, etc.)
        for w in ignoredViews {
            if let v = w.view, touchedView.isDescendant(of: v) { return false }
        }

        return true
    }
}

private final class WeakView {
    weak var view: UIView?
    init(_ view: UIView) { self.view = view }
}

private extension UIView {
    func closestSuperview<T: UIView>(of _: T.Type) -> T? {
        var v: UIView? = self
        while let current = v {
            if let match = current as? T { return match }
            v = current.superview
        }
        return nil
    }
}

public extension UIViewController {
    /// Call once (usually in `viewDidLoad`) and you're done.
    func enableKeyboardDismissOnOutsideTap(ignoring views: [UIView] = []) {
        // Prevent adding multiple recognizers if called twice
        if objc_getAssociatedObject(self, &_keyboardDismissHandlerKey) != nil { return }

        let handler = KeyboardDismissHandler(hostView: view, ignored: views)
        let tap = UITapGestureRecognizer(target: handler, action: #selector(KeyboardDismissHandler.handleTap))
        tap.cancelsTouchesInView = false // critical: don’t break buttons/cell selection
        tap.delegate = handler
        view.addGestureRecognizer(tap)

        objc_setAssociatedObject(self, &_keyboardDismissHandlerKey, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}



//final class ProfileVC: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        enableKeyboardDismissOnOutsideTap()
//    }
//}
