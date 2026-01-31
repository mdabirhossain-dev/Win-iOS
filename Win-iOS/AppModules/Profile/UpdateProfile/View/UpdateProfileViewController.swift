//
//
//  UpdateProfileViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 11/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class UpdateProfileViewController: UIViewController {

    // MARK: - VIPER
    var presenter: UpdateProfilePresenterProtocol?

    // MARK: - UI
    private let rootScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let rootStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 12
        stack.axis = .vertical
        stack.alignment = .fill
        return stack
    }()

    private let avatarStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        stack.axis = .vertical
        stack.alignment = .center
        stack.applyCornerRadious(10)
        stack.backgroundColor = .wcPinkLight
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        return stack
    }()

    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .winProfileCircle)
        imageView.tintColor = .white
        imageView.applyCornerRadious(20)
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private let updateAvatarButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.font(
            .winFont(.semiBold, size: .small),
            title: AppConstants.Profile.UpdateProfile.updateButton,
            color: .wcVelvetDark
        )
        button.applyCornerRadious(20, borderWidth: 1, borderColor: .wcVelvetDark)

        var config = button.configuration ?? .plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        button.configuration = config
        return button
    }()

    private let numberTextFieldLabel: WinTextField = {
        let field = WinTextField()
        field.borderColor = .gray
        field.leftImage = UIImage(systemName: "phone")?.withTintColor(.black)
        field.rightImage = UIImage(resource: .success)
        field.backgroundColor = .white
        field.isUserInteractionEnabled = false
        field.isEnabled = false
        return field
    }()

    private let userNameTextField: WinTextField = {
        let field = WinTextField()
        field.borderColor = .gray
        field.leftImage = UIImage(resource: .winProfileCircle).withTintColor(.gray)
        field.placeholder = AppConstants.Profile.HelpAndSupport.yourFullName
        field.backgroundColor = .white
        return field
    }()

    private let saveButton: WinButton = {
        let button = WinButton(background: .solid(.wcVelvet))
        button.setTitle(AppConstants.Profile.UpdateProfile.save, for: .normal)
        return button
    }()

    // MARK: - DI seed (kept for compatibility)
    private var seededName: String = ""
    private var seededAvatarUrl: String = ""

    func inject(userInfo: UpdateProfileRequest, avatarUrl: String) {
        seededName = userInfo.fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        seededAvatarUrl = avatarUrl
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

        // seed initial UI (presenter will re-render after fetch)
        userNameTextField.text = seededName
        profileImageView.setImage(from: seededAvatarUrl, placeholder: UIImage(resource: .winProfileCircle))

        presenter?.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.applyCornerRadious(profileImageView.bounds.height / 2)
    }

    private func setupView() {
        setupNavigationBar(isBackButton: true, delegate: self)
        view.backgroundColor = .wcBackground

        view.addSubview(rootScrollView)
        rootScrollView.addSubview(rootStackView)

        rootStackView.addArrangedSubviews([
            avatarStackView,
            numberTextFieldLabel,
            userNameTextField,
            saveButton
        ])

        avatarStackView.addArrangedSubviews([profileImageView, updateAvatarButton])

        updateAvatarButton.addTarget(self, action: #selector(didTapUpdateAvatar), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)

        NSLayoutConstraint.activate([
            rootScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rootScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            rootScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            rootStackView.topAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.topAnchor, constant: 16),
            rootStackView.leadingAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            rootStackView.trailingAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            rootStackView.bottomAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.bottomAnchor, constant: -16),

            rootStackView.widthAnchor.constraint(equalTo: rootScrollView.frameLayoutGuide.widthAnchor, constant: -32),

            profileImageView.heightAnchor.constraint(equalToConstant: 96),
            profileImageView.widthAnchor.constraint(equalToConstant: 96),

            updateAvatarButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Actions
    @objc private func didTapUpdateAvatar() {
        presenter?.didTapUpdateAvatar()
    }

    @objc private func didTapSave() {
        presenter?.didTapSave(enteredName: userNameTextField.text)
    }
}

// MARK: - View Protocol
extension UpdateProfileViewController: UpdateProfileViewProtocol {

    func setLoading(_ isLoading: Bool) {
        showLoader(isLoading ? .loading : .hidden)
    }

    func render(_ vm: UpdateProfileScreenViewModel) {
        numberTextFieldLabel.placeholder = vm.msisdnText
        if userNameTextField.text?.isEmpty ?? true {
            userNameTextField.text = vm.userNameText
        }

        if let url = vm.avatarURL {
            profileImageView.setImage(from: url, placeholder: UIImage(resource: .winProfileCircle))
        }
    }

    func showToast(_ message: String, isError: Bool) {
        Toast.show(message, style: isError ? .error : .info)
    }

    func showSuccessAndPop(title: String, message: String) {
        Alert.show(
            AlertConfig(
                title: title,
                message: message,
                icon: .image(.alert),
                buttons: .ok()
            ),
            onOK: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )
    }

    func showAlert(title: String, message: String) {
        Alert.show(AlertConfig(title: title, message: message, icon: .image(.alert), buttons: .ok()))
    }
}

// MARK: - NavigationBarDelegate
extension UpdateProfileViewController: NavigationBarDelegate {
    func navBarDidTapBack(in vc: UIViewController) {
        presenter?.didTapBack()
    }
}

// MARK: - Avatar Picker Delegate (forward to presenter)
extension UpdateProfileViewController: AvatarPickerViewControllerDelegate {
    func avatarPicker(_ vc: AvatarPickerViewController, didConfirm avatar: UserAvatar) {
        presenter?.didSelectAvatar(avatar)
    }
}
//final class UpdateProfileViewController: UIViewController {
//    
//    // MARK: - UI Properties
//    private let rootScrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        return scrollView
//    }()
//    
//    private let rootStackView: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.spacing = 12
//        stack.axis = .vertical
//        stack.alignment = .fill
//        return stack
//    }()
//    
//    private let avatarStackView: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.spacing = 8
//        stack.axis = .vertical
//        stack.alignment = .center
//        stack.applyCornerRadious(10)
//        stack.backgroundColor = .wcPinkLight
//        stack.isLayoutMarginsRelativeArrangement = true
//        stack.layoutMargins = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
//        return stack
//    }()
//
//    private let profileImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.image = UIImage(resource: .winProfileCircle)
//        imageView.tintColor = .white
//        imageView.applyCornerRadious(20)
//        imageView.contentMode = .scaleAspectFill
//        return imageView
//    }()
//    
//    private let updateAvatarButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.font(
//            .winFont(.semiBold, size: .small),
//            title: AppConstants.Profile.UpdateProfile.updateButton,
//            color: .wcVelvetDark
//        )
//        button.applyCornerRadious(20, borderWidth: 1, borderColor: .wcVelvetDark)
//        
//        var config = button.configuration ?? .plain()
//        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
//        button.configuration = config
//        return button
//    }()
//    
//    private let numberTextFieldLabel: WinTextField = {
//        let field = WinTextField()
//        field.borderColor = .gray
//        field.leftImage = UIImage(systemName: "phone")?.withTintColor(.black)
//        field.rightImage = UIImage(resource: .success)
//        field.placeholder = KeychainManager.shared.msisdn.dropLeading88().toBanglaNumberWithSuffix()
//        field.backgroundColor = .white
//        field.isUserInteractionEnabled = false
//        field.isEnabled = false
//        return field
//    }()
//
//    private let userNameTextField: WinTextField = {
//        let field = WinTextField()
//        field.borderColor = .gray
//        field.leftImage = UIImage(resource: .winProfileCircle).withTintColor(.gray)
//        field.placeholder = AppConstants.Profile.HelpAndSupport.yourFullName
//        field.backgroundColor = .white
//        return field
//    }()
//    
//    private let saveButton: WinButton = {
//        let button = WinButton(background: .solid(.wcVelvet))
//        button.setTitle(AppConstants.Profile.UpdateProfile.save, for: .normal)
//        return button
//    }()
//
//    // MARK: - Dependencies
//    private let userInfo: UpdateProfileRequest
//    private let avatarUrl: String
//    private let viewModel = UpdateProfileViewModel()
//
//    // MARK: - Minimal State (only what matters)
//    private var originalName: String
//    private var originalAvatarId: Int?     // server truth after getUserAvatar()
//    private var selectedAvatarId: Int?     // current selection
//    private var selectedAvatarImageURL: String?
//
//    init(_ userInfo: UpdateProfileRequest, avatarUrl: String) {
//        self.userInfo = userInfo
//        self.avatarUrl = avatarUrl
//
//        // Seed initial snapshot from passed-in data (will be refined by getUserAvatar())
//        self.originalName = userInfo.fullName.trimmingCharacters(in: .whitespacesAndNewlines)
//        self.originalAvatarId = Int(userInfo.userAvatarId)
//        self.selectedAvatarId = Int(userInfo.userAvatarId)
//
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//        bindViewModel()
//
//        userNameTextField.text = originalName
//        profileImageView.setImage(from: avatarUrl, placeholder: UIImage(resource: .winProfileCircle))
//
//        viewModel.getUserAvatar()
//        viewModel.getAvatarList()
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        profileImageView.applyCornerRadious(profileImageView.bounds.height / 2)
//    }
//
//    // MARK: - Binding
//    private func bindViewModel() {
//        viewModel.onUserAvatarLoaded = { [weak self] avatar in
//            guard let self else { return }
//
//            // Server truth overrides local seed
//            self.originalAvatarId = avatar.userAvatarId
//            self.selectedAvatarId = avatar.userAvatarId
//            self.selectedAvatarImageURL = avatar.imageSource
//
//            if let url = avatar.imageSource {
//                self.profileImageView.setImage(from: url, placeholder: UIImage(resource: .winProfileCircle))
//            }
//        }
//
//        viewModel.onProfileUpdated = { [weak self] _ in
//            guard let self else { return }
//
//            // Update snapshot to new committed values
//            self.originalName = (self.userNameTextField.text ?? "")
//                .trimmingCharacters(in: .whitespacesAndNewlines)
//
//            self.originalAvatarId = self.selectedAvatarId ?? self.originalAvatarId
//
//            Alert.show(
//                AlertConfig(
//                    title: "সফল",
//                    message: "প্রোফাইল সফলভাবে আপডেট করা হয়েছে",
//                    icon: .image(.alert),
//                    buttons: .ok()
//                ), onOK:  {
//                    self.navigationController?.popViewController(animated: true)
//                })
//        }
//
//        viewModel.onError = { message in
//            Toast.show(message, style: .error)
//        }
//    }
//
//    // MARK: - Setup
//    private func setupView() {
//        setupNavigationBar(isBackButton: true, delegate: self)
//        view.backgroundColor = .wcBackground
//
//        view.addSubview(rootScrollView)
//        rootScrollView.addSubview(rootStackView)
//
//        rootStackView.addArrangedSubviews([
//            avatarStackView,
//            numberTextFieldLabel,
//            userNameTextField,
//            saveButton
//        ])
//
//        avatarStackView.addArrangedSubviews([
//            profileImageView,
//            updateAvatarButton
//        ])
//
//        updateAvatarButton.addTarget(self, action: #selector(didTapUpdateAvatar), for: .touchUpInside)
//        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
//
//        NSLayoutConstraint.activate([
//            rootScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            rootScrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            rootScrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            rootScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//
//            rootStackView.topAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.topAnchor, constant: 16),
//            rootStackView.leadingAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.leadingAnchor, constant: 16),
//            rootStackView.trailingAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.trailingAnchor, constant: -16),
//            rootStackView.bottomAnchor.constraint(equalTo: rootScrollView.contentLayoutGuide.bottomAnchor, constant: -16),
//
//            rootStackView.widthAnchor.constraint(equalTo: rootScrollView.frameLayoutGuide.widthAnchor, constant: -32),
//
//            profileImageView.heightAnchor.constraint(equalToConstant: 96),
//            profileImageView.widthAnchor.constraint(equalToConstant: 96),
//
//            updateAvatarButton.heightAnchor.constraint(equalToConstant: 40),
//            saveButton.heightAnchor.constraint(equalToConstant: 44)
//        ])
//    }
//
//    // MARK: - Actions
//    @objc private func didTapUpdateAvatar() {
//        guard let list = viewModel.userAvatarList, !list.isEmpty else {
//            Alert.show(
//                AlertConfig(
//                    title: "অপেক্ষা করুন",
//                    message: "অ্যাভাটার লোড হচ্ছে",
//                    icon: .image(.alert),
//                    buttons: .ok()
//                )
//            )
//            return
//        }
//
//        let picker = AvatarPickerViewController(
//            avatars: list,
//            initiallySelectedId: selectedAvatarId ?? originalAvatarId
//        )
//        picker.delegate = self
//        picker.modalPresentationStyle = .overFullScreen
//        picker.modalTransitionStyle = .crossDissolve
//        present(picker, animated: true)
//    }
//    
//    @objc private func didTapSave() {
//        let newName = (userNameTextField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
//        let newAvatarId = selectedAvatarId ?? originalAvatarId
//        
//        let didChangeName = (newName != originalName)
//        let didChangeAvatar = (newAvatarId != originalAvatarId)
//
//        guard didChangeName || didChangeAvatar else {
//            Toast.show("আপডেট করার জন্য তথ্য পরিবর্তন করুন")
//            return
//        }
//        
//        let request = UpdateProfileRequest(
//            fullName: newName,
//            gender: userInfo.gender,
//            userAvatarId: newAvatarId.map(String.init) ?? userInfo.userAvatarId
//        )
//
//        viewModel.updateProfile(request: request)
//    }
//}
//
//// MARK: - NavigationBarDelegate
//extension UpdateProfileViewController: NavigationBarDelegate {
//    func navBarDidTapBack(in vc: UIViewController) {
//        navigationController?.popViewController(animated: true)
//    }
//}
//
//// MARK: - AvatarPicker Delegate
//extension UpdateProfileViewController: AvatarPickerViewControllerDelegate {
//    func avatarPicker(_ vc: AvatarPickerViewController, didConfirm avatar: UserAvatar) {
//        selectedAvatarId = avatar.userAvatarId
//        selectedAvatarImageURL = avatar.imageSource
//
//        if let url = avatar.imageSource {
//            profileImageView.setImage(from: url, placeholder: UIImage(resource: .winProfileCircle))
//        }
//    }
//}
//





