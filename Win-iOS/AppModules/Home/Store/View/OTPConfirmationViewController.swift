//
//
//  OTPConfirmationViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 22/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import UIKit

final class OTPConfirmationViewController: UIViewController {

    // MARK: - Callbacks
    var onSubmit: ((String) -> Void)?
    var onCancel: (() -> Void)?

    private let imageURLString: String?

    // MARK: - UI
    private let dimView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        return view
    }()

    private let containerView: UIVisualEffectView = {
        let blur = UIBlurEffect(style: .systemThinMaterial)
        let view = UIVisualEffectView(effect: blur)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 18
        return view
    }()

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .label
        label.font = .winFont(.semiBold, size: .medium)
        label.text = "ওটিপি প্রদান করুন"
        return label
    }()

    private let otpTextField: WinTextField = {
        let textField = WinTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .gray
        textField.leftImage = UIImage(systemName: "lock")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        textField.placeholder = AppConstants.Home.Store.enterOTP
        textField.keyboardType = .numberPad
        textField.returnKeyType = .done
        return textField
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("বাতিল করুন", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .winFont(.regular, size: .medium)
        button.backgroundColor = UIColor.systemGray5
        button.layer.cornerRadius = 12
        return button
    }()

    private let okButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("সাবমিট", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .winFont(.semiBold, size: .medium)
        button.backgroundColor = .wcVelvet
        button.layer.cornerRadius = 12
        return button
    }()

    private let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        return stackView
    }()

    private var containerCenterYConstraint: NSLayoutConstraint?

    // MARK: - Init
    init(imageURLString: String?) {
        self.imageURLString = imageURLString
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    deinit { NotificationCenter.default.removeObserver(self) }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupActions()
        setupKeyboardHandling()
        loadHeaderImage()
    }

    private func loadHeaderImage() {
        guard let urlString = imageURLString, !urlString.isEmpty else { return }
        // ✅ Use your loader here
        iconImageView.setImage(from: urlString)
    }

    private func setupView() {
        view.backgroundColor = .clear

        view.addSubview(dimView)
        view.addSubview(containerView)

        containerView.contentView.addSubview(iconImageView)
        containerView.contentView.addSubview(titleLabel)
        containerView.contentView.addSubview(otpTextField)
        containerView.contentView.addSubview(buttonsStackView)

        buttonsStackView.addArrangedSubview(cancelButton)
        buttonsStackView.addArrangedSubview(okButton)

        containerCenterYConstraint = containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor)

        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerCenterYConstraint!,
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),
            containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 340),

            iconImageView.topAnchor.constraint(equalTo: containerView.contentView.topAnchor, constant: 18),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.contentView.centerXAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 34),
            iconImageView.widthAnchor.constraint(equalToConstant: 34),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.contentView.leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.contentView.trailingAnchor, constant: -18),

            otpTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            otpTextField.leadingAnchor.constraint(equalTo: containerView.contentView.leadingAnchor, constant: 18),
            otpTextField.trailingAnchor.constraint(equalTo: containerView.contentView.trailingAnchor, constant: -18),
            otpTextField.heightAnchor.constraint(equalToConstant: 44),

            buttonsStackView.topAnchor.constraint(equalTo: otpTextField.bottomAnchor, constant: 16),
            buttonsStackView.leadingAnchor.constraint(equalTo: containerView.contentView.leadingAnchor, constant: 18),
            buttonsStackView.trailingAnchor.constraint(equalTo: containerView.contentView.trailingAnchor, constant: -18),
            buttonsStackView.heightAnchor.constraint(equalToConstant: 44),
            buttonsStackView.bottomAnchor.constraint(equalTo: containerView.contentView.bottomAnchor, constant: -18)
        ])

        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOutside))
        dimView.addGestureRecognizer(tap)
    }

    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        okButton.addTarget(self, action: #selector(didTapOk), for: .touchUpInside)
    }

    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ note: Notification) {
        guard let userInfo = note.userInfo,
              let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        containerCenterYConstraint?.constant = -min(120, frame.height * 0.25)
        UIView.animate(withDuration: 0.25) { self.view.layoutIfNeeded() }
    }

    @objc private func keyboardWillHide(_ note: Notification) {
        containerCenterYConstraint?.constant = 0
        UIView.animate(withDuration: 0.25) { self.view.layoutIfNeeded() }
    }

    @objc private func didTapOutside() {
        dismiss(animated: true)
        onCancel?()
    }

    @objc private func didTapCancel() {
        dismiss(animated: true)
        onCancel?()
    }

    @objc private func didTapOk() {
        let otp = (otpTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        guard !otp.isEmpty else {
            Toast.show("ওটিপি দিন", style: .error)
            return
        }

        okButton.isEnabled = false
        cancelButton.isEnabled = false

        dismiss(animated: true)
        onSubmit?(otp)
    }
}
