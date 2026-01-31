//
//
//  SignInViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 14/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

class SignInViewController: UIViewController {

    // MARK: - UI Properties
    private let rootScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let titleView: TitleWithDescriptionView = {
        let view = TitleWithDescriptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topImageView.image = UIImage(resource: .winLogoText)
        view.titleLabel.text = AppConstants.Auth.logInTitle
        view.descriptionLabel.text = AppConstants.Auth.logInDescription
        return view
    }()

    private let userNameTextField: WinTextField = {
        let textField = WinTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .gray
        textField.text = KeychainManager.shared.msisdn
        textField.leftImage = UIImage(systemName: "phone")?.withTintColor(.black)
        textField.placeholder = AppConstants.Auth.phoneNumberPlaceholder
        return textField
    }()

    private let passwordTextField: WinTextField = {
        let textField = WinTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderColor = .gray
        textField.text = KeychainManager.shared.password
        textField.leftImage = UIImage(systemName: "exclamationmark.lock")?.withTintColor(.black)
        textField.rightImage = UIImage(systemName: "eye.slash")
        textField.placeholder = AppConstants.Auth.passwordPlaceholder
        textField.rightImageColor = .lightGray
        return textField
    }()

    private let authActionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let rememberMeCheckBoxButton: CheckboxButton = {
        let button = CheckboxButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isSelected = true
        button.tintColor = .wcGreen
        return button
    }()

    private let rememberMeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = AppConstants.Auth.rememberMe
        label.textColor = .gray
        label.font = .winFont(.regular, size: .small)
        return label
    }()

    private let forgotPasswordButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(AppConstants.Auth.forgotPassword, for: .normal)
        button.setTitleColor(.wcVelvet, for: .normal)
        button.titleLabel?.font = .winFont(.semiBold, size: .small)
        return button
    }()

    private let signInButton: WinButton = {
        let button = WinButton(background: .solid(.wcVelvet))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(AppConstants.Auth.signIn, for: .normal)
        return button
    }()

    private let registrationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let notRegisteredYetLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = AppConstants.Auth.notRegisteredYet
        label.font = .winFont(.regular, size: .small)
        return label
    }()

    private let registerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("   " + AppConstants.Auth.registerNow, for: .normal)
        button.setTitleColor(.wcVelvet, for: .normal)
        button.titleLabel?.font = .winFont(.semiBold, size: .medium)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .top
        return button
    }()

    private let orDoSignInLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = AppConstants.Auth.orDoSignUp
        label.textColor = .gray
        label.font = .winFont(.regular, size: .extraSmall)
        return label
    }()

    private let signInWithGoogleButton: WinButtonWithImage = {
        let button = WinButtonWithImage(textColor: .black,
                                        image: UIImage(resource: .logoGoogle))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(AppConstants.Auth.signInWithGoogle, for: .normal)
        return button
    }()

    private let signInWithFacebookButton: WinButtonWithImage = {
        let button = WinButtonWithImage(textColor: .black,
                                        image: UIImage(resource: .logoFacebook))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(AppConstants.Auth.signInWithFacebook, for: .normal)
        return button
    }()

    private let rulesAndRegulationsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let termsAndConditionCheckmarkButton: CheckboxButton = {
        let button = CheckboxButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let termsAndConditionView: TermsAndConditionsView = {
        let view = TermsAndConditionsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.fullText = "আপনি WIN এর নিয়ম ও শর্তাবলি এবং গোপনীয়তার নীতিমালার সাথে সম্মত।"
        view.links = [
            ("নিয়ম ও শর্তাবলি", "https://www.mdabirhossain--11.com"),
            ("গোপনীয়তার নীতিমালার", "https://www.mdabirhossain--22.com")
        ]
        view.onLinkTap = { url in
            Log.info("OpenWebView: \(url)")
        }
        return view
    }()

    // MARK: - Presenter
    var presenter: SignInPresenterProtocol?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Setup
    private func setupView() {
        view.addSubview(rootScrollView)
        rootScrollView.addSubview(rootStackView)

        rootStackView.addArrangedSubviews([
            titleView,
            userNameTextField,
            passwordTextField,
            authActionStackView,
            signInButton,
            registrationStackView,
            orDoSignInLabel,
            signInWithGoogleButton,
            signInWithFacebookButton,
            rulesAndRegulationsStackView
        ])

        authActionStackView.addArrangedSubviews([
            rememberMeCheckBoxButton,
            rememberMeLabel,
            forgotPasswordButton
        ])

        registrationStackView.addArrangedSubviews([
            notRegisteredYetLabel,
            registerButton
        ])

        rulesAndRegulationsStackView.addArrangedSubviews([
            termsAndConditionCheckmarkButton,
            termsAndConditionView
        ])

        // Targets
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonAction), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonAction), for: .touchUpInside)
        signInWithGoogleButton.addTarget(self, action: #selector(signInWithGoogleButtonAction), for: .touchUpInside)
        signInWithFacebookButton.addTarget(self, action: #selector(signInWithFacebookButtonAction), for: .touchUpInside)

        // Layout
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

            authActionStackView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            authActionStackView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),

            rememberMeCheckBoxButton.leadingAnchor.constraint(equalTo: authActionStackView.leadingAnchor),
            rememberMeCheckBoxButton.widthAnchor.constraint(equalToConstant: 24),

            signInButton.leadingAnchor.constraint(equalTo: authActionStackView.leadingAnchor),
            signInButton.trailingAnchor.constraint(equalTo: authActionStackView.trailingAnchor),
            signInButton.heightAnchor.constraint(equalToConstant: 44),

            registrationStackView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            notRegisteredYetLabel.heightAnchor.constraint(equalToConstant: 32),
            registerButton.leadingAnchor.constraint(equalTo: notRegisteredYetLabel.trailingAnchor),

            orDoSignInLabel.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            orDoSignInLabel.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),

            signInWithGoogleButton.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            signInWithGoogleButton.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            signInWithGoogleButton.heightAnchor.constraint(equalToConstant: 48),

            signInWithFacebookButton.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            signInWithFacebookButton.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            signInWithFacebookButton.heightAnchor.constraint(equalToConstant: 48),

            rulesAndRegulationsStackView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            rulesAndRegulationsStackView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func forgotPasswordButtonAction() {
        Log.info("tapped")
        presenter?.didTapForgotPassword()
    }

    @objc private func signInButtonAction() {
        Log.info("tapped")
        presenter?.didTapSignIn(
            phone: userNameTextField.text,
            password: passwordTextField.text,
            isSaveCredentials: rememberMeCheckBoxButton.isSelected
        )
    }

    @objc private func registerButtonAction() {
        Log.info("tapped")
        presenter?.didTapRegister()
    }

    @objc private func signInWithGoogleButtonAction() {
        Log.info("tapped")
        presenter?.didTapSignInWithGoogle()
    }

    @objc private func signInWithFacebookButtonAction() {
        Log.info("tapped")
        presenter?.didTapSignInWithFacebook()
    }
}

// MARK: - SignInViewProtocol
extension SignInViewController: SignInViewProtocol {

    func showLoading() {
        showLoader(.loading)
    }

    func hideLoading() {
        showLoader(.hidden)
    }

    func showInlineError(message: String) { }
    func hideInlineError() { }

    func showToast(message: String, isError: Bool) {
        Toast.show(message, style: isError ? .error : .success)
    }

    func updateResendButton(enabled: Bool, title: String) { }
}
