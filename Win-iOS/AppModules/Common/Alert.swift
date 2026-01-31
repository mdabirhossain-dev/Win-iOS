//
//
//  Alert.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/12/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit
import Lottie

// MARK: - Public API
public enum AlertButtons {
    case ok(title: String = "ঠিক আছে")
    case yesNo(yesTitle: String = "হ্যাঁ", noTitle: String = "না")
}

public enum AlertIcon {
    case image(UIImage)
    case lottie(LottieFiles, loop: LottieLoopMode = .loop, speed: CGFloat = 1.0)
    case none
}

public struct AlertConfig {
    public var title: String
    public var message: String?
    public var icon: AlertIcon
    public var buttons: AlertButtons
    public var dismissOnBackgroundTap: Bool
    
    public init(title: String,
                message: String? = nil,
                icon: AlertIcon = .none,
                buttons: AlertButtons = .ok(),
                dismissOnBackgroundTap: Bool = false) {
        self.title = title
        self.message = message
        self.icon = icon
        self.buttons = buttons
        self.dismissOnBackgroundTap = dismissOnBackgroundTap
    }
}

public final class Alert {
    public static func show(_ config: AlertConfig,
                            onOK: (() -> Void)? = nil,
                            onYes: (() -> Void)? = nil,
                            onNo: (() -> Void)? = nil) {
        AlertPresenter.shared.show(config, onOK: onOK, onYes: onYes, onNo: onNo)
    }
    
    public static func dismiss() {
        AlertPresenter.shared.dismissCurrent()
    }
}

// MARK: - Presenter (overlay UIWindow above everything)
private final class AlertPresenter {
    
    static let shared = AlertPresenter()
    
    private var window: UIWindow?
    private var host: AlertHostViewController?
    
    // ✅ make it STRONG (weak causes random nils)
    private var previousKeyWindow: UIWindow?
    
    private var isShowing = false
    private var queue: [(AlertConfig, (() -> Void)?, (() -> Void)?, (() -> Void)?)] = []
    
    func show(_ config: AlertConfig,
              onOK: (() -> Void)?,
              onYes: (() -> Void)?,
              onNo: (() -> Void)?) {
        
        DispatchQueue.main.async {
            if self.isShowing {
                self.queue.append((config, onOK, onYes, onNo))
                return
            }
            self.isShowing = true
            self.present(config, onOK: onOK, onYes: onYes, onNo: onNo)
        }
    }
    
    func dismissCurrent() {
        DispatchQueue.main.async {
            self.dismissAndNext(then: nil)
        }
    }
    
    private func present(_ config: AlertConfig,
                         onOK: (() -> Void)?,
                         onYes: (() -> Void)?,
                         onNo: (() -> Void)?) {
        
        guard let scene = UIApplication.shared.bestWindowScene else {
            finishAndNext()
            return
        }
        
        // ✅ Save the app window. If keyWindow is nil, fallback to a normal-level window.
        previousKeyWindow = scene.windows.first(where: { $0.isKeyWindow })
        ?? scene.windows.first(where: { $0.windowLevel == .normal })
        ?? scene.windows.first
        
        let w = UIWindow(windowScene: scene)
        w.frame = scene.coordinateSpace.bounds
        w.windowLevel = .alert + 2
        w.backgroundColor = .clear
        
        let vc = AlertHostViewController(
            config: config,
            onOK: { [weak self] in self?.dismissAndNext(then: onOK) },
            onYes: { [weak self] in self?.dismissAndNext(then: onYes) },
            onNo: { [weak self] in self?.dismissAndNext(then: onNo) },
            onDismiss: { [weak self] in self?.dismissAndNext(then: nil) }
        )
        
        w.rootViewController = vc
        window = w
        host = vc
        
        // Overlay must be key to receive touches
        w.makeKeyAndVisible()
        vc.presentAnimated()
    }
    
    private func dismissAndNext(then action: (() -> Void)?) {
        guard let host else {
            teardownWindow()
            run(action)
            finishAndNext()
            return
        }
        
        host.dismissAnimated { [weak self] in
            guard let self else { return }
            self.teardownWindow()
            self.run(action)
            self.finishAndNext()
        }
    }
    
    private func teardownWindow() {
        window?.isHidden = true
        window?.rootViewController = nil
        window = nil
        host = nil
        
        // ✅ Restore app key window (makeKey preferred)
        if let prev = previousKeyWindow {
            prev.makeKey()
            if prev.isHidden { prev.isHidden = false } // safety
        }
        previousKeyWindow = nil
    }
    
    // ✅ Run callback on next runloop tick after key window restore
    private func run(_ action: (() -> Void)?) {
        guard let action else { return }
        DispatchQueue.main.async { action() }
    }
    
    private func finishAndNext() {
        isShowing = false
        if !queue.isEmpty {
            let next = queue.removeFirst()
            show(next.0, onOK: next.1, onYes: next.2, onNo: next.3)
        }
    }
}

// MARK: - Host VC UI
private final class AlertHostViewController: UIViewController {
    
    private let config: AlertConfig
    private let onOK: () -> Void
    private let onYes: () -> Void
    private let onNo: () -> Void
    private let onDismiss: () -> Void
    
    private let dimView = UIView()
    private let card = UIView()
    
    private let iconWrap = UIView()
    private let iconCircle = UIView()
    private let imageView = UIImageView()
    private let lottieContainer = LottieAnimationViewContainer()
    
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    
    private let buttonStack = UIStackView()
    
    init(config: AlertConfig,
         onOK: @escaping () -> Void,
         onYes: @escaping () -> Void,
         onNo: @escaping () -> Void,
         onDismiss: @escaping () -> Void) {
        self.config = config
        self.onOK = onOK
        self.onYes = onYes
        self.onNo = onNo
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func presentAnimated() {
        dimView.alpha = 0
        card.alpha = 0
        card.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
        
        UIView.animate(withDuration: 0.22, delay: 0, options: [.curveEaseOut]) {
            self.dimView.alpha = 1
            self.card.alpha = 1
            self.card.transform = .identity
        }
    }
    
    func dismissAnimated(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseIn]) {
            self.dimView.alpha = 0
            self.card.alpha = 0
            self.card.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        } completion: { _ in completion?() }
    }
    
    private func setup() {
        view.backgroundColor = .clear
        
        // Dim
        dimView.translatesAutoresizingMaskIntoConstraints = false
        dimView.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        view.addSubview(dimView)
        
        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if config.dismissOnBackgroundTap {
            let tap = UITapGestureRecognizer(target: self, action: #selector(bgTapped))
            tap.cancelsTouchesInView = true
            dimView.addGestureRecognizer(tap)
        }
        
        // Card
        card.translatesAutoresizingMaskIntoConstraints = false
        card.backgroundColor = .systemBackground
        card.layer.cornerRadius = 14
        card.layer.cornerCurve = .continuous
        card.layer.masksToBounds = true
        view.addSubview(card)
        
        NSLayoutConstraint.activate([
            card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            card.widthAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.85),
            card.widthAnchor.constraint(greaterThanOrEqualToConstant: 270)
        ])
        
        let content = UIStackView()
        content.translatesAutoresizingMaskIntoConstraints = false
        content.axis = .vertical
        content.alignment = .fill
        content.spacing = 10
        content.isLayoutMarginsRelativeArrangement = true
        content.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        card.addSubview(content)
        
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: card.topAnchor),
            content.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            content.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            content.bottomAnchor.constraint(equalTo: card.bottomAnchor)
        ])
        
        // Icon wrap + circle
        iconWrap.translatesAutoresizingMaskIntoConstraints = false
        iconCircle.translatesAutoresizingMaskIntoConstraints = false
        iconCircle.applyCornerRadious(34)
        
        NSLayoutConstraint.activate([
            iconCircle.heightAnchor.constraint(equalToConstant: 68),
            iconCircle.widthAnchor.constraint(equalToConstant: 68)
        ])
        
        iconWrap.addSubview(iconCircle)
        NSLayoutConstraint.activate([
            iconCircle.centerXAnchor.constraint(equalTo: iconWrap.centerXAnchor),
            iconCircle.topAnchor.constraint(equalTo: iconWrap.topAnchor),
            iconCircle.bottomAnchor.constraint(equalTo: iconWrap.bottomAnchor)
        ])
        
        content.addArrangedSubview(iconWrap)
        
        // Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.text = config.title
        content.addArrangedSubview(titleLabel)
        
        // Message
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = .systemFont(ofSize: 15, weight: .regular)
        messageLabel.textColor = .secondaryLabel
        messageLabel.text = config.message
        messageLabel.isHidden = (config.message?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
        content.addArrangedSubview(messageLabel)
        
        // Buttons
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.axis = .horizontal
        buttonStack.alignment = .fill
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 12
        content.addArrangedSubview(buttonStack)
        
        setupIcon()
        setupButtons()
    }
    
    private func setupIcon() {
        iconCircle.subviews.forEach { $0.removeFromSuperview() }
        lottieContainer.stopAnimation()
        
        switch config.icon {
        case .none:
            iconWrap.isHidden = true
            
        case .image(let img):
            iconWrap.isHidden = false
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = img
            imageView.contentMode = .scaleAspectFit
            iconCircle.addSubview(imageView)
            
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: iconCircle.centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: iconCircle.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 54),
                imageView.heightAnchor.constraint(equalToConstant: 54)
            ])
            
        case .lottie(let file, let loop, let speed):
            iconWrap.isHidden = false
            lottieContainer.translatesAutoresizingMaskIntoConstraints = false
            iconCircle.addSubview(lottieContainer)
            
            NSLayoutConstraint.activate([
                lottieContainer.centerXAnchor.constraint(equalTo: iconCircle.centerXAnchor),
                lottieContainer.centerYAnchor.constraint(equalTo: iconCircle.centerYAnchor),
                lottieContainer.widthAnchor.constraint(equalToConstant: 54),
                lottieContainer.heightAnchor.constraint(equalToConstant: 54)
            ])
            
            lottieContainer.setAnimation(named: file, loopMode: loop, speed: speed, autoPlay: true)
        }
    }
    
    private func setupButtons() {
        
        func style(_ button: UIButton, isPrimary: Bool) {
            var cfg = UIButton.Configuration.filled()
            cfg.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
            cfg.baseBackgroundColor = isPrimary ? .wcVelvet : .secondarySystemBackground
            cfg.baseForegroundColor = isPrimary ? .white : .label
            button.configuration = cfg
            
            button.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
            button.layer.cornerRadius = 20
            button.layer.cornerCurve = .continuous
            button.layer.masksToBounds = true
            
            button.configurationUpdateHandler = { btn in
                btn.alpha = btn.isHighlighted ? 0.92 : 1.0
                btn.transform = btn.isHighlighted ? CGAffineTransform(scaleX: 0.99, y: 0.99) : .identity
            }
        }
        
        buttonStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        switch config.buttons {
        case .ok(let title):
            let b = UIButton(type: .system)
            style(b, isPrimary: true)
            b.configuration?.title = title
            b.addTarget(self, action: #selector(okTap), for: .touchUpInside)
            buttonStack.addArrangedSubview(b)
            
        case .yesNo(let yesTitle, let noTitle):
            let no = UIButton(type: .system)
            let yes = UIButton(type: .system)
            
            style(no, isPrimary: false)
            style(yes, isPrimary: true)
            
            no.configuration?.title = noTitle
            yes.configuration?.title = yesTitle
            
            no.addTarget(self, action: #selector(noTap), for: .touchUpInside)
            yes.addTarget(self, action: #selector(yesTap), for: .touchUpInside)
            
            buttonStack.addArrangedSubview(no)
            buttonStack.addArrangedSubview(yes)
        }
    }
    
    @objc private func bgTapped() { onDismiss() }
    @objc private func okTap() { onOK() }
    @objc private func yesTap() { onYes() }
    @objc private func noTap() { onNo() }
}

// MARK: - UIApplication helpers

private extension UIApplication {
    var bestWindowScene: UIWindowScene? {
        let scenes = connectedScenes.compactMap { $0 as? UIWindowScene }
        return scenes.first(where: { $0.activationState == .foregroundActive })
        ?? scenes.first(where: { $0.activationState == .foregroundInactive })
        ?? scenes.first
    }
}

//// Success with OK
//Alert.show(
//    AlertConfig(
//        title: "সফল হয়েছে",
//        message: "আপনার পাসওয়ার্ডটি আপডেট হয়েছে",
//        icon: .lottie(.success, loop: .loop, speed: 1.0),
//        buttons: .ok(title: "ঠিক আছে")
//    ),
//    onOK: {
//        // navigate / dismiss / whatever
//    }
//)
//
//// Confirm Yes/No
//Alert.show(
//    AlertConfig(
//        title: "আপনি কি নিশ্চিত?",
//        message: nil,
//        icon: .lottie(.failed, loop: .loop, speed: 1.0),
//        buttons: .yesNo(yesTitle: "হ্যাঁ", noTitle: "না")
//    ),
//    onYes: { /* do it */ },
//    onNo: { /* cancel */ }
//)
//
//// Static project icon (no lottie)
//Alert.show(
//    AlertConfig(
//        title: "সফল হয়েছে",
//        message: "আপডেট সম্পন্ন",
//        icon: .image(UIImage(named: "AppToastIcon")!),
//        buttons: .ok()
//    )
//)
