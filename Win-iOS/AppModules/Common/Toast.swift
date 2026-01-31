//
//
//  Toast.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/12/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

public enum ToastStyle {
    case success
    case error
    case info
    
    var backgroundColor: UIColor {
        switch self {
        case .success: return UIColor.wcGreen.withAlphaComponent(0.92)
        case .error:   return UIColor.systemPink.withAlphaComponent(0.92)
        case .info:    return UIColor.black.withAlphaComponent(0.85)
        }
    }
}

public final class Toast {
    
    // MARK: - Public API (call from anywhere)
    public static func show(_ message: String,
                            style: ToastStyle = .info,
                            duration: TimeInterval = 2.0) {
        ToastPresenter.shared.show(message: message, style: style, duration: duration)
    }
}

// MARK: - Presenter
private final class ToastPresenter {
    
    static let shared = ToastPresenter()
    
    private var toastWindow: UIWindow?
    private var isShowing = false
    private var pending: [(String, ToastStyle, TimeInterval)] = []
    
    func show(message: String, style: ToastStyle, duration: TimeInterval) {
        DispatchQueue.main.async {
            if self.isShowing {
                self.pending.append((message, style, duration))
                return
            }
            self.isShowing = true
            self.present(message: message, style: style, duration: duration)
        }
    }
    
    private func present(message: String, style: ToastStyle, duration: TimeInterval) {
        guard let windowScene = UIApplication.shared.activeWindowScene else {
            self.finishAndShowNext()
            return
        }
        
        let window = PassthroughWindow(windowScene: windowScene)
        window.windowLevel = .alert + 1
        window.backgroundColor = .clear
        
        let hostVC = UIViewController()
        hostVC.view.backgroundColor = .clear
        window.rootViewController = hostVC
        
        window.isHidden = false
        self.toastWindow = window
        
        let toastView = ToastView(message: message, background: style.backgroundColor)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        hostVC.view.addSubview(toastView)
        
        let guide = hostVC.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -80),
            toastView.widthAnchor.constraint(lessThanOrEqualTo: guide.widthAnchor, multiplier: 0.9)
        ])
        
        toastView.alpha = 0
        toastView.transform = CGAffineTransform(translationX: 0, y: 80)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseOut]) {
            toastView.alpha = 1
            toastView.transform = .identity
        } completion: { _ in
            UIView.animate(withDuration: 0.25, delay: duration, options: [.curveEaseIn]) {
                toastView.alpha = 0
                toastView.transform = CGAffineTransform(translationX: 0, y: 80)
            } completion: { _ in
                toastView.removeFromSuperview()
                window.isHidden = true
                self.toastWindow = nil
                self.finishAndShowNext()
            }
        }
    }
    
    private func finishAndShowNext() {
        self.isShowing = false
        if !pending.isEmpty {
            let next = pending.removeFirst()
            self.show(message: next.0, style: next.1, duration: next.2)
        }
    }
}

// MARK: - Toast UI
private final class ToastView: UIView {
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        
        return label
    }()
    
    init(message: String, background: UIColor) {
        super.init(frame: .zero)
        
        backgroundColor = background
        layer.cornerRadius = 12
        layer.masksToBounds = true
        
        label.text = message
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Touch passthrough window (toast won't block taps)
private final class PassthroughWindow: UIWindow {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // only capture touches if user taps the toast itself; otherwise pass through
        guard let root = rootViewController?.view else { return false }
        for sub in root.subviews {
            if !sub.isHidden, sub.alpha > 0,
               sub.frame.contains(point) {
                return true
            }
        }
        return false
    }
}

// MARK: - Active Window Scene Helper
private extension UIApplication {
    var activeWindowScene: UIWindowScene? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first(where: { $0.activationState == .foregroundActive })
    }
}

//Toast.show("OTP Verified!", style: .success)
//Toast.show("OTP Verification Failed", style: .error)

