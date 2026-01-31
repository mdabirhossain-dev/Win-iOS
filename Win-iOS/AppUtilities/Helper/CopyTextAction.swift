//
//
//  CopyTextAction.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 29/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//



import UIKit
import ObjectiveC

// MARK: - Reusable Copy Action
struct CopyTextAction {
    let textProvider: () -> String
    var pasteboard: UIPasteboard = .general
    var onCopied: ((String) -> Void)? = nil

    func perform() {
        let text = textProvider().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        pasteboard.string = text
        onCopied?(text)
    }
}

// MARK: - Reusable Share Action
struct ShareSheetAction {
    let itemsProvider: () -> [Any]
    var excludedActivityTypes: [UIActivity.ActivityType]? = nil
    var onComplete: UIActivityViewController.CompletionWithItemsHandler? = nil

    func perform(from presenter: UIViewController, sourceView: UIView?) {
        let items = itemsProvider()
        guard !items.isEmpty else { return }

        let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
        vc.excludedActivityTypes = excludedActivityTypes
        vc.completionWithItemsHandler = onComplete

        // iPad popover anchor (avoids crash)
        if let popover = vc.popoverPresentationController {
            popover.sourceView = sourceView ?? presenter.view
            popover.sourceRect = (sourceView ?? presenter.view).bounds
        }

        presenter.present(vc, animated: true)
    }
}

// MARK: - UIButton tap binding (iOS 13+)
private final class ButtonActionTrampoline: NSObject {
    let handler: () -> Void
    init(_ handler: @escaping () -> Void) { self.handler = handler }
    @objc func invoke() { handler() }
}

private var buttonTrampolinesKey: UInt8 = 0

extension UIButton {
    private var trampolines: [ButtonActionTrampoline] {
        get { (objc_getAssociatedObject(self, &buttonTrampolinesKey) as? [ButtonActionTrampoline]) ?? [] }
        set { objc_setAssociatedObject(self, &buttonTrampolinesKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func onTap(_ handler: @escaping () -> Void) {
        if #available(iOS 14.0, *) {
            addAction(UIAction { _ in handler() }, for: .touchUpInside)
        } else {
            let trampoline = ButtonActionTrampoline(handler)
            addTarget(trampoline, action: #selector(ButtonActionTrampoline.invoke), for: .touchUpInside)
            trampolines.append(trampoline) // retain
        }
    }

    func bindCopy(_ action: CopyTextAction) {
        onTap { action.perform() }
    }

    func bindShare(_ action: ShareSheetAction, presenter: UIViewController, sourceView: UIView? = nil) {
        onTap { [weak presenter, weak self] in
            guard let presenter else { return }
            action.perform(from: presenter, sourceView: sourceView ?? self)
        }
    }
}


//// MARK: - Reusable Copy Action
//struct CopyTextAction {
//    let textProvider: () -> String
//    var pasteboard: UIPasteboard = .general
//    var onCopied: ((String) -> Void)? = nil
//
//    func perform() {
//        let text = textProvider()
//        guard !text.isEmpty else { return }
//        pasteboard.string = text
//        onCopied?(text)
//    }
//}
//
//// MARK: - UIButton Binding (Reusable)
//extension UIButton {
//
//    /// Bind a CopyTextAction to this button
//    func bindCopy(_ action: CopyTextAction, for controlEvents: UIControl.Event = .touchUpInside) {
//        addAction(UIAction { _ in
//            action.perform()
//        }, for: controlEvents)
//    }
//
//    /// Bind a ShareSheetAction to this button
//    func bindShare(_ action: ShareSheetAction,
//                   presenter: UIViewController,
//                   sourceView: UIView? = nil,
//                   for controlEvents: UIControl.Event = .touchUpInside) {
//        addAction(UIAction { [weak presenter, weak self] _ in
//            guard let presenter else { return }
//            action.perform(from: presenter, sourceView: sourceView ?? self)
//        }, for: controlEvents)
//    }
//}
