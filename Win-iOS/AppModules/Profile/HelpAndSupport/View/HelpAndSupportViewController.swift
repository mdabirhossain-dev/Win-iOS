//
//
//  HelpAndSupportViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class HelpAndSupportViewController: UIViewController, HelpAndSupportViewProtocol {

    // MARK: - Presenter
    var presenter: HelpAndSupportPresenterProtocol!

    // MARK: - UI Properties
    private let rootScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentInsetAdjustmentBehavior = .always
        scrollView.keyboardDismissMode = .interactive
        return scrollView
    }()

    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 12
        return stackView
    }()

    private let informationStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.backgroundColor = .white
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        stackView.applyCornerRadious(10, borderWidth: 1, borderColor: .lightGray.withAlphaComponent(0.2))
        return stackView
    }()

    private let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "envelope")
        imageView.tintColor = .wcVelvet
        imageView.backgroundColor = .wcPinkLight
        imageView.contentMode = .center
        return imageView
    }()

    private let supportEmailTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = AppConstants.Profile.HelpAndSupport.supportEmail
        label.font = .winFont(.regular, size: .extraSmall)
        label.textColor = .gray
        return label
    }()

    private let supportEmailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = AppConstants.Profile.HelpAndSupport.win2gainEmail
        label.font = .winFont(.bold, size: .small)
        label.textColor = .wcVelvetDark
        return label
    }()

    private let userNameTextField: WinTextField = {
        let textField = WinTextField()
        textField.leftImage = UIImage(systemName: "person.fill")?.withTintColor(.black)
        textField.placeholder = AppConstants.Profile.HelpAndSupport.yourFullName
        textField.borderColor = .gray
        textField.backgroundColor = .white
        return textField
    }()

    private let numberTextField: WinTextField = {
        let textField = WinTextField()
        textField.leftImage = UIImage(systemName: "phone")?.withTintColor(.black)
        textField.rightImage = UIImage(resource: .success)
        textField.placeholder = KeychainManager.shared.msisdn.dropLeading88().toBanglaNumberWithSuffix()
        textField.borderColor = .gray
        textField.backgroundColor = .white
        textField.isUserInteractionEnabled = false
        return textField
    }()

    private let userEmailTextField: WinTextField = {
        let textField = WinTextField()
        textField.leftImage = UIImage(systemName: "envelope")?.withTintColor(.black)
        textField.placeholder = AppConstants.Profile.HelpAndSupport.email
        textField.borderColor = .gray
        textField.backgroundColor = .white
        textField.keyboardType = .emailAddress
        return textField
    }()

    private let descriptionTextView: WinTextView = {
        let textView = WinTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.placeholder = "বার্তাটি লিখুন*"
        textView.textContainer.lineFragmentPadding = 0
        textView.borderColor = .gray
        return textView
    }()

    private let submitButton: WinButton = {
        let button = WinButton(background: .solid(.wcVelvet))
        button.setTitle(AppConstants.Profile.HelpAndSupport.submit, for: .normal)
        return button
    }()

    private let descriptionInputLimiter = InputLimiter(maxLength: 500)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        messageImageView.applyCornerRadious(messageImageView.bounds.height / 2)
    }

    // MARK: - Setup
    private func setupView() {
        setupNavigationBar(isBackButton: true, delegate: self)
        view.backgroundColor = .wcBackground

        view.addSubview(rootScrollView)
        rootScrollView.addSubview(rootStackView)

        rootStackView.addArrangedSubviews([
            informationStackView,
            userNameTextField,
            numberTextField,
            userEmailTextField,
            descriptionTextView,
            submitButton
        ])

        informationStackView.addArrangedSubviews([
            messageImageView,
            supportEmailTitleLabel,
            supportEmailLabel
        ])

        descriptionTextView.delegate = descriptionInputLimiter
        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)

        NSLayoutConstraint.activate([
            rootScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rootScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            rootScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            rootStackView.topAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: rootScrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            rootStackView.trailingAnchor.constraint(equalTo: rootScrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            rootStackView.bottomAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.bottomAnchor),

            informationStackView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            informationStackView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),

            messageImageView.heightAnchor.constraint(equalToConstant: 40),
            messageImageView.widthAnchor.constraint(equalToConstant: 40),

            descriptionTextView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),

            submitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Actions
    @objc private func didTapSubmit() {
        presenter.didTapSubmit(
            name: userNameTextField.text,
            phone: numberTextField.text, // may be empty; presenter will fallback to keychain msisdn
            email: userEmailTextField.text,
            message: descriptionTextView.text
        )
    }

    // MARK: - HelpAndSupportViewProtocol
    func setLoading(_ isLoading: Bool) {
        submitButton.isEnabled = !isLoading
        view.isUserInteractionEnabled = !isLoading

        // ✅ use your global loader overlay
        if isLoading {
            showLoader(.loading)
        } else {
            showLoader(.hidden)
        }
    }

    func showSuccess(message: String) {
        Alert.show(
            AlertConfig(
                title: "সফল",
                message: message,
                icon: .lottie(.success, loop: .loop, speed: 1.0),
                buttons: .ok(title: "ঠিক আছে")
            ),
            onOK: { [weak self] in
                self?.presenter.didTapBack()
            }
        )
    }

    func showError(message: String) {
        Toast.show(message, style: .error)
    }
}

// MARK: - NavigationBarDelegate
extension HelpAndSupportViewController: NavigationBarDelegate {
    func navBarDidTapBack(in vc: UIViewController) {
        presenter.didTapBack()
    }
}

//final class HelpAndSupportViewController: UIViewController, HelpAndSupportViewProtocol {
//    
//    // MARK: - Presenter
//    var presenter: HelpAndSupportPresenterProtocol!
//    
//    // MARK: - UI Properties
//    private let rootScrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.contentInsetAdjustmentBehavior = .always
//        scrollView.keyboardDismissMode = .interactive
//        return scrollView
//    }()
//    
//    private let rootStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.alignment = .fill
//        stackView.spacing = 12
//        return stackView
//    }()
//    
//    private let informationStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .vertical
//        stackView.alignment = .center
//        stackView.spacing = 8
//        stackView.backgroundColor = .white
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        stackView.applyCornerRadious(10, borderWidth: 1, borderColor: .lightGray.withAlphaComponent(0.2))
//        return stackView
//    }()
//    
//    private let messageImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(systemName: "envelope")
//        imageView.tintColor = .wcVelvet
//        imageView.backgroundColor = .wcPinkLight
//        imageView.contentMode = .center
//        return imageView
//    }()
//    
//    private let supportEmailTitleLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = AppConstants.Profile.HelpAndSupport.supportEmail
//        label.font = .winFont(.regular, size: .extraSmall)
//        label.textColor = .gray
//        return label
//    }()
//    
//    private let supportEmailLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = AppConstants.Profile.HelpAndSupport.win2gainEmail
//        label.font = .winFont(.bold, size: .small)
//        label.textColor = .wcVelvetDark
//        return label
//    }()
//    
//    private let userNameTextField: WinTextField = {
//        let textField = WinTextField()
//        textField.leftImage = UIImage(systemName: "person.fill")?.withTintColor(.black)
//        textField.placeholder = AppConstants.Profile.HelpAndSupport.yourFullName
//        textField.borderColor = .gray
//        textField.backgroundColor = .white
//        return textField
//    }()
//    
//    private let numberTextField: WinTextField = {
//        let textField = WinTextField()
//        textField.leftImage = UIImage(systemName: "phone")?.withTintColor(.black)
//        textField.rightImage = UIImage(resource: .success)
//        textField.placeholder = KeychainManager.shared.msisdn.dropLeading88().toBanglaNumberWithSuffix()
//        textField.borderColor = .gray
//        textField.backgroundColor = .white
//        textField.isUserInteractionEnabled = false
//        return textField
//    }()
//    
//    private let userEmailTextField: WinTextField = {
//        let textField = WinTextField()
//        textField.leftImage = UIImage(systemName: "envelope")?.withTintColor(.black)
//        textField.placeholder = AppConstants.Profile.HelpAndSupport.email
//        textField.borderColor = .gray
//        textField.backgroundColor = .white
//        textField.keyboardType = .emailAddress
//        return textField
//    }()
//    
//    private let descriptionTextView: WinTextView = {
//        let textView = WinTextView()
//        textView.translatesAutoresizingMaskIntoConstraints = false
//        textView.placeholder = "বার্তাটি লিখুন*"
//        textView.textContainer.lineFragmentPadding = 0
//        textView.borderColor = .gray
//        return textView
//    }()
//    
//    private let submitButton: WinButton = {
//        let button = WinButton(background: .solid(.wcVelvet))
//        button.setTitle(AppConstants.Profile.HelpAndSupport.submit, for: .normal)
//        return button
//    }()
//    
//    private let descriptionInputLimiter = InputLimiter(maxLength: 500)
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//        presenter.viewDidLoad()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        messageImageView.applyCornerRadious(messageImageView.bounds.height / 2)
//    }
//    
//    // MARK: - Setup
//    private func setupView() {
//        setupNavigationBar(isBackButton: true, delegate: self)
//        
//        view.backgroundColor = .wcBackground
//        
//        view.addSubview(rootScrollView)
//        rootScrollView.addSubview(rootStackView)
//        
//        rootStackView.addArrangedSubviews([
//            informationStackView,
//            userNameTextField,
//            numberTextField,
//            userEmailTextField,
//            descriptionTextView,
//            submitButton
//        ])
//        informationStackView.addArrangedSubviews([
//            messageImageView,
//            supportEmailTitleLabel,
//            supportEmailLabel
//        ])
//        
//        descriptionTextView.delegate = descriptionInputLimiter
//        
//        submitButton.addTarget(self, action: #selector(didTapSubmit), for: .touchUpInside)
//        
//        NSLayoutConstraint.activate([
//            rootScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            rootScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            rootScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            rootScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            
//            rootStackView.topAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.topAnchor),
//            rootStackView.leadingAnchor.constraint(equalTo: rootScrollView.frameLayoutGuide.leadingAnchor, constant: 16),
//            rootStackView.trailingAnchor.constraint(equalTo: rootScrollView.frameLayoutGuide.trailingAnchor, constant: -16),
//            rootStackView.bottomAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.bottomAnchor),
//            
//            informationStackView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
//            informationStackView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
//            
//            messageImageView.heightAnchor.constraint(equalToConstant: 40),
//            messageImageView.widthAnchor.constraint(equalToConstant: 40),
//            
//            descriptionTextView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
//            descriptionTextView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
//            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),
//            
//            submitButton.heightAnchor.constraint(equalToConstant: 44)
//        ])
//    }
//    
//    // MARK: - Actions
//    @objc private func didTapSubmit() {
//        presenter.didTapSubmit(
//            name: userNameTextField.text,
//            phone: numberTextField.text,
//            email: userEmailTextField.text,
//            message: descriptionTextView.text
//        )
//    }
//    
//    // MARK: - HelpAndSupportViewProtocol
//    func setLoading(_ isLoading: Bool) {
//        submitButton.isEnabled = !isLoading
//    }
//    
//    func showSuccess(message: String) {
//        Alert.show(
//            AlertConfig(
//                title: "সফল",
//                message:message,
//                icon: .lottie(.success, loop: .loop, speed: 1.0),
//                buttons: .ok(title: "ঠিক আছে")
//            ), onOK: {
//                self.presenter.didTapBack()
//            }
//        )
//    }
//    
//    func showError(message: String) {
//        Toast.show(message, style: .error)
//    }
//}
//
//// MARK: - NavigationBarDelegate
//extension HelpAndSupportViewController: NavigationBarDelegate {
//    func navBarDidTapBack(in vc: UIViewController) {
//        presenter.didTapBack()
//    }
//}
