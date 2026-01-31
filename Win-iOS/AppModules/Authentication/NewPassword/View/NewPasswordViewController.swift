//
//
//  NewPasswordViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 10/12/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class NewPasswordViewController: UIViewController {

    // MARK: - VIPER
    var presenter: NewPasswordPresenterProtocol?

    // MARK: - UI
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
        view.descriptionLabel.text = AppConstants.Auth.PasswordReset.typeRegisteredPhoneNumber
        return view
    }()

    private let newPasswordTextField: WinTextField = {
        let field = WinTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderColor = .gray
        field.leftImage = UIImage(systemName: "phone")
        field.rightImage = UIImage(systemName: "eye.slash")
        field.rightImageColor = .gray
        field.placeholder = AppConstants.Auth.NewPassword.enterNewPassword
        field.keyboardType = .numberPad
        return field
    }()

    private let renterPasswordTextField: WinTextField = {
        let field = WinTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderColor = .gray
        field.leftImage = UIImage(systemName: "phone")
        field.rightImage = UIImage(systemName: "eye.slash")
        field.rightImageColor = .gray
        field.placeholder = AppConstants.Auth.NewPassword.reenterPassword
        field.keyboardType = .numberPad
        return field
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .red
        label.font = .winFont(.regular, size: .small)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.isHidden = true
        return label
    }()

    private let submitButton: WinButton = {
        let button = WinButton(background: .solid(.wcVelvet))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(AppConstants.Auth.signUp, for: .normal)
        return button
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()

    // MARK: - Required init params (still used for UI init, presenter gets these via Router)
    private let msisdn: String
    private let otp: String

    init(msisdn: String, otp: String) {
        self.msisdn = msisdn
        self.otp = otp
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(presenter != nil, "You MUST open this VC via NewPasswordRouter.createModule(msisdn:otp:)")

        setupView()
        presenter?.viewDidLoad()
    }

    // MARK: - Setup
    private func setupView() {
        setupNavigationBar(isBackButton: true, delegate: self)

        view.backgroundColor = .wcBackground
        view.addSubviews([rootScrollView, activityIndicator])
        rootScrollView.addSubview(rootStackView)

        rootStackView.addArrangedSubviews([
            titleView,
            newPasswordTextField,
            renterPasswordTextField,
            errorLabel,
            submitButton
        ])

        submitButton.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)

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

            newPasswordTextField.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            newPasswordTextField.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),

            renterPasswordTextField.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            renterPasswordTextField.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),

            errorLabel.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),

            submitButton.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 44),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    // MARK: - Actions
    @objc private func submitButtonTapped() {
        presenter?.didTapSubmit(
            newPassword: newPasswordTextField.text,
            reenterPassword: renterPasswordTextField.text
        )
        view.endEditing(true)
    }
}

// MARK: - View Protocol
extension NewPasswordViewController: NewPasswordViewProtocol {

    func setLoading(_ isLoading: Bool) {
        if isLoading {
            activityIndicator.startAnimating()
            submitButton.isEnabled = false
        } else {
            activityIndicator.stopAnimating()
            submitButton.isEnabled = true
        }
    }

    func showValidationError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }

    func clearValidationError() {
        errorLabel.text = nil
        errorLabel.isHidden = true
    }

    func showErrorToast(_ message: String) {
        Toast.show(message, style: .error)
    }

    func showSuccessAndGoRoot() {
        Alert.show(
            AlertConfig(
                title: "সফল হয়েছে",
                message: "আপনার পাসওয়ার্ডটি আপডেট হয়েছে",
                icon: .lottie(.success, loop: .loop, speed: 1.0),
                buttons: .ok(title: "ঠিক আছে")
            ),
            onOK: { [weak self] in
                guard let self else { return }
                // router will do it, but keeping your exact behavior is fine:
                self.navigationController?.popToRootViewController(animated: true)
            }
        )
    }
}

// MARK: - NavigationBarDelegate
extension NewPasswordViewController: NavigationBarDelegate {
    func navBarDidTapBack(in vc: UIViewController) {
        presenter?.didTapBack()
    }
}
