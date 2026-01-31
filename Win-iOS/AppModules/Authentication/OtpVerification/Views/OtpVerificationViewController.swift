//
//
//  OtpVerificationViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 14/10/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//

import UIKit

final class OtpVerificationViewController: UIViewController {

    // MARK: - Presenter
    var presenter: OtpVerificationPresenterProtocol?

    // MARK: - UI Properties
    private let rootScrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let rootStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let titleView: TitleWithDescriptionView = {
        let view = TitleWithDescriptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topImageView.image = UIImage(resource: .winOTP)
        view.titleLabel.text = AppConstants.Auth.mobileVerification
        return view
    }()

    private let otpTextField: WinTextField = {
        let field = WinTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderColor = .gray
        field.leftImage = UIImage(systemName: "exclamationmark.lock")
        field.rightImage = UIImage(systemName: "eye.slash")
        field.rightImageColor = .gray
        field.placeholder = AppConstants.Auth.typeOTP
        field.keyboardType = .numberPad
        return field
    }()

    private let signUpButton: WinButton = {
        let button = WinButton(background: .solid(.wcVelvet))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(AppConstants.Auth.signUp, for: .normal)
        return button
    }()

    private let registrationStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.spacing = .leastNonzeroMagnitude
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let otpNotReceivedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = AppConstants.Auth.otpNotReceived
        label.font = .winFont(.regular, size: .medium)
        return label
    }()

    private let resendOtpButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  " + AppConstants.Auth.sendAgain, for: .normal)
        button.setTitleColor(.wcVelvet, for: .normal)
        button.titleLabel?.font = .winFont(.semiBold, size: .medium)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .top
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoad()
    }

    // MARK: - Setup
    private func setupView() {
        setupNavigationBar(isBackButton: true, delegate: self)

        view.backgroundColor = .wcBackground
        view.addSubview(rootScrollView)
        view.addSubview(activityIndicator)

        rootScrollView.addSubview(rootStackView)

        rootStackView.addArrangedSubviews([
            titleView,
            otpTextField,
            signUpButton,
            registrationStackView
        ])

        registrationStackView.addArrangedSubviews([
            otpNotReceivedLabel,
            resendOtpButton
        ])

        // Targets
        otpTextField.addTarget(self, action: #selector(otpTextDidChange), for: .editingChanged)
        signUpButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        resendOtpButton.addTarget(self, action: #selector(resendOtpButtonTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            rootScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rootScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            rootScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            rootStackView.centerXAnchor.constraint(equalTo: rootScrollView.centerXAnchor),
            rootStackView.topAnchor.constraint(equalTo: rootScrollView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: rootScrollView.leadingAnchor, constant: 20),
            rootStackView.trailingAnchor.constraint(equalTo: rootScrollView.trailingAnchor, constant: -20),
            rootStackView.bottomAnchor.constraint(equalTo: rootScrollView.bottomAnchor),

            otpTextField.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            otpTextField.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),

            signUpButton.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 44),

            registrationStackView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            otpNotReceivedLabel.heightAnchor.constraint(equalToConstant: 32),
            resendOtpButton.leadingAnchor.constraint(equalTo: otpNotReceivedLabel.trailingAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Public
    func setPhoneNumber(_ phoneNumber: String) {
        titleView.descriptionLabel.text = AppConstants.Auth.otpSendToRegisteredMobileNumber + "\n\(phoneNumber)"
    }

    // MARK: - Actions
    @objc private func submitButtonTapped() {
        presenter?.didTapSubmit(otp: otpTextField.text)
    }

    @objc private func resendOtpButtonTapped() {
        presenter?.didTapResendOtp()
    }

    @objc private func otpTextDidChange() {
        if let text = otpTextField.text, text.count > 6 {
            otpTextField.text = String(text.prefix(6))
        }
    }
}

// MARK: - NavigationBarDelegate
extension OtpVerificationViewController: NavigationBarDelegate {
    func navBarDidTapBack(in vc: UIViewController) {
        presenter?.router?.dismissView()
    }
}

// MARK: - OtpVerificationViewProtocol
extension OtpVerificationViewController: OtpVerificationViewProtocol {

    func showLoading() {
        activityIndicator.startAnimating()
        signUpButton.isEnabled = false
        resendOtpButton.isEnabled = false
        otpTextField.isEnabled = false
        view.isUserInteractionEnabled = false
    }

    func hideLoading() {
        activityIndicator.stopAnimating()
        signUpButton.isEnabled = true
        resendOtpButton.isEnabled = true
        otpTextField.isEnabled = true
        view.isUserInteractionEnabled = true
    }

    func showToast(message: String, isError: Bool) {
        Toast.show(message, style: isError ? .error : .success)
    }

    func updateResendButton(enabled: Bool, title: String) {
        resendOtpButton.isEnabled = enabled
        resendOtpButton.setTitle("  " + title, for: .normal)
        resendOtpButton.alpha = enabled ? 1.0 : 0.5
    }

    func clearOtpField() {
        otpTextField.text = ""
    }
}
