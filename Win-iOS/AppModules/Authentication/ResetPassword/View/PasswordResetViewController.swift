//
//
//  PasswordResetViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 9/12/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class PasswordResetViewController: UIViewController {

    var presenter: PasswordResetPresenterProtocol?

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

    private let phoneNumberTextField: WinTextField = {
        let field = WinTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderColor = .gray
        field.leftImage = UIImage(systemName: "phone")
        field.rightImageColor = .gray
        field.placeholder = AppConstants.Auth.PasswordReset.phoneNumber
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

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(presenter != nil, "Open via PasswordResetRouter.createModule()")
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
            phoneNumberTextField,
            errorLabel,
            submitButton
        ])

        phoneNumberTextField.addTarget(self, action: #selector(phoneNumberTextDidChange), for: .editingChanged)
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

            phoneNumberTextField.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),

            errorLabel.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            
            submitButton.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func submitButtonTapped() {
        presenter?.didTapSubmit(msisdn: phoneNumberTextField.text)
        view.endEditing(true)
    }

    @objc private func phoneNumberTextDidChange() {
        if let text = phoneNumberTextField.text, text.count > 11 {
            phoneNumberTextField.text = String(text.prefix(11))
        }
        presenter?.didChangePhoneText(phoneNumberTextField.text)
    }
}

// MARK: - View Protocol
extension PasswordResetViewController: PasswordResetViewProtocol {

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
}

// MARK: - NavigationBarDelegate
extension PasswordResetViewController: NavigationBarDelegate {
    func navBarDidTapBack(in vc: UIViewController) {
        presenter?.didTapBack()
    }
}
