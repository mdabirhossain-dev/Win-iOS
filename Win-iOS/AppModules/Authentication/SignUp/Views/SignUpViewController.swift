//
//
//  SignUpViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 14/10/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Presenter
    var presenter: SignUpPresenterProtocol?
    
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
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleView: TitleWithDescriptionView = {
        let view = TitleWithDescriptionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.topImageView.image = UIImage(resource: .winLogoText)
        view.titleLabel.text = AppConstants.Auth.registerTitle
        view.descriptionLabel.text = AppConstants.Auth.registerDescription
        return view
    }()
    
    private let phoneNumberTextField: WinTextField = {
        let field = WinTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderColor = .gray
        field.leftImage = UIImage(systemName: "phone.fill")
        field.placeholder = AppConstants.Auth.phoneNumberPlaceholder
        return field
    }()
    
    private let passwordTextField: WinTextField = {
        let field = WinTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderColor = .gray
        field.leftImage = UIImage(systemName: "exclamationmark.lock")
        field.rightImage = UIImage(systemName: "eye.slash")
        field.rightImageColor = .gray
        field.placeholder = AppConstants.Auth.passwordPlaceholder
        return field
    }()
    
    private let referrelCodeTextField: WinTextField = {
        let field = WinTextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.borderColor = .gray
        field.leftImage = UIImage(systemName: "document.on.document")
        field.placeholder = AppConstants.Auth.writeReferrelCode
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
        stack.spacing = .leastNonzeroMagnitude
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let alreadyRegisteredLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = AppConstants.Auth.alreadyRegistered
        label.font = .winFont(.regular, size: .medium)
        return label
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("  " + AppConstants.Auth.doSignIn, for: .normal)
        button.setTitleColor(.wcVelvet, for: .normal)
        button.titleLabel?.font = .winFont(.semiBold, size: .medium)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .top
        return button
    }()
    
    private let orDoSignUp: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = AppConstants.Auth.orDoSignUp
        label.textAlignment = .left
        label.textColor = .gray
        label.font = .winFont(.regular, size: .extraSmall)
        return label
    }()
    
    private let signUpWithGoogleButton: WinButtonWithImage = {
        let button = WinButtonWithImage(textColor: .black,
                                        image: UIImage(resource: .logoGoogle))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(AppConstants.Auth.registerWithGmail, for: .normal)
        return button
    }()
    
    private let signUpWithFacebookButton: WinButtonWithImage = {
        let button = WinButtonWithImage(textColor: .black, image: UIImage(resource: .logoFacebook))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(AppConstants.Auth.registerWithFacebook, for: .normal)
        return button
    }()
    
    private let rulesAndRegulationsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .leading
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let termsAndConditionCheckmarkButton: CheckboxButton = {
        let button = CheckboxButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let termsAndConditionView: TermsAndConditionsView = {
        let view = TermsAndConditionsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.fullText = "রেজিস্ট্রেশনের মাধ্যমে, আপনি WIN এর গোপনীয়তা নীতি এবং ব্যবহারকারীর শর্তাবলীতে সম্মত হন।"
        view.links = [
            ("গোপনীয়তা নীতি", "https://www.mdabirhossain--11.com"),
            ("ব্যবহারকারীর শর্তাবলীতে", "https://www.mdabirhossain--22.com")
        ]
        view.onLinkTap = { url in Log.info("OpenWebView: \(url)") }
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        setupNavigationBar(isBackButton: true, delegate: self)
        view.backgroundColor = .wcBackground
        
        view.addSubview(rootScrollView)
        rootScrollView.addSubview(rootStackView)
        
        rootStackView.addArrangedSubviews([
            titleView,
            phoneNumberTextField,
            passwordTextField,
            referrelCodeTextField,
            signUpButton,
            registrationStackView,
            orDoSignUp,
            signUpWithGoogleButton,
            signUpWithFacebookButton,
            rulesAndRegulationsStackView
        ])
        
        registrationStackView.addArrangedSubviews([
            alreadyRegisteredLabel,
            signInButton
        ])
        
        rulesAndRegulationsStackView.addArrangedSubviews([
            termsAndConditionCheckmarkButton,
            termsAndConditionView
        ])
        
        // Targets
        signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        signUpWithGoogleButton.addTarget(self, action: #selector(signUpWithGoogleButtonAction), for: .touchUpInside)
        signUpWithFacebookButton.addTarget(self, action: #selector(signUpWithFacebookButtonAction), for: .touchUpInside)
        
        // Constraints (moved from setupLayout)
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
            
            signUpButton.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            signUpButton.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 44),
            
            registrationStackView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            alreadyRegisteredLabel.heightAnchor.constraint(equalToConstant: 32),
            signInButton.leadingAnchor.constraint(equalTo: alreadyRegisteredLabel.trailingAnchor),
            
            orDoSignUp.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            orDoSignUp.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            
            signUpWithGoogleButton.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            signUpWithGoogleButton.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            signUpWithGoogleButton.heightAnchor.constraint(equalToConstant: 48),
            
            signUpWithFacebookButton.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            signUpWithFacebookButton.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            signUpWithFacebookButton.heightAnchor.constraint(equalToConstant: 48),
            
            rulesAndRegulationsStackView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            rulesAndRegulationsStackView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func signUpButtonAction() {
        Log.info("tapped")
        
        guard let msisdn = phoneNumberTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let invitationCode = referrelCodeTextField.text else { return }
        
        let userInfo = SignUpUserInfo(msisdn: msisdn, password: password, invitationCode: invitationCode)
        
        presenter?.didTapSignUp(userInfo: userInfo)
    }
    
    @objc private func signInButtonAction() {
        Log.info("tapped")
        presenter?.router?.navigateBackToSignInScreen()
    }
    
    @objc private func signUpWithGoogleButtonAction() {
        Log.info("tapped")
    }
    
    @objc private func signUpWithFacebookButtonAction() {
        Log.info("tapped")
    }
}

// MARK: - NavigationBarDelegate
extension SignUpViewController: NavigationBarDelegate {
    func navBarDidTapBack(in vc: UIViewController) {
        presenter?.router?.dismissView()
    }
}

// MARK: - SignUpViewProtocol
extension SignUpViewController: SignUpViewProtocol {

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
