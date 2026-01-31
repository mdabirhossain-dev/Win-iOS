//
//
//  GiftPointViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 30/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit
import ContactsUI

final class GiftPointViewController: UIViewController {

    var presenter: GiftPointPresenterProtocol?

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let pointsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let pointsView: ScoreBreakdownView = {
        let view = ScoreBreakdownView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let otherPointsView: ScoreBreakdownView = {
        let view = ScoreBreakdownView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var receiversNumberHeaderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.Profile.GiftPoint.receiversNumberTitle
        label.textColor = .wcVelvet
        label.font = .winFont(.semiBold, size: .small)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let receiversNumberTextField: WinTextField = {
        let textField = WinTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftImage = UIImage(systemName: "phone")?.withTintColor(.black)
        textField.placeholder = AppConstants.Profile.GiftPoint.receiversNumberPlaceholder
        textField.borderColor = .gray
        textField.backgroundColor = .white
        textField.keyboardType = .phonePad
        return textField
    }()

    private lazy var contactsButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(resource: .contactsBook), for: .normal)
        button.tintColor = .wcVelvet
        button.addTarget(self, action: #selector(didTapContactsButton), for: .touchUpInside)

        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 28),
            button.heightAnchor.constraint(equalToConstant: 28)
        ])
        return button
    }()

    private var pointTypeHeaderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.Profile.GiftPoint.pointTypeTitle
        label.textColor = .wcVelvet
        label.font = .winFont(.semiBold, size: .small)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var chipBar: SelectableChipBar<PointBreakdown> = {
        let view = SelectableChipBar<PointBreakdown>()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.onSelectionChanged = { [weak self] selectedPointBreakdown, _ in
            self?.selectedPointBreakdown = selectedPointBreakdown
        }
        return view
    }()

    private var pointAmountHeaderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.Profile.GiftPoint.pointAmountTitle
        label.textColor = .wcVelvet
        label.font = .winFont(.semiBold, size: .small)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let pointAmountTextField: WinTextField = {
        let textField = WinTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftImage = UIImage(resource: .starCircle)
        textField.placeholder = AppConstants.Profile.GiftPoint.pointAmountPlaceholder
        textField.borderColor = .gray
        textField.backgroundColor = .white
        textField.keyboardType = .numberPad
        return textField
    }()

    private lazy var pointAmountQuickPickBar: PointAmountQuickPickBar = {
        let view = PointAmountQuickPickBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setValues([100, 200, 300, 400, 500])
        view.onValueTapped = { [weak self] value in
            self?.pointAmountTextField.text = "\(value)"
        }
        return view
    }()

    private let giftButton: WinButton = {
        let button = WinButton(height: 40, cornerRadius: 20, background: .solid(.wcVelvet))
        button.font(.winFont(.regular, size: .medium), title: "গিফট করুন", color: .white)
        return button
    }()

    private var selectedPointBreakdown: PointBreakdown?

    override func viewDidLoad() {
        super.viewDidLoad()
        assert(presenter != nil, "Open via GiftPointRouter.createModule(userSummary:)")
        setupView()
        presenter?.viewDidLoad()

        giftButton.addTarget(self, action: #selector(giftButtonTapped), for: .touchUpInside)
    }

    @objc private func giftButtonTapped() {
        presenter?.didTapGift(
            receiverMSISDN: receiversNumberTextField.text,
            pointAmountText: pointAmountTextField.text,
            selectedWallet: selectedPointBreakdown
        )
    }

    private func setupView() {
        setupNavigationBar(isBackButton: true, delegate: self)
        view.backgroundColor = .wcBackground

        view.addSubview(scrollView)
        scrollView.addSubview(rootStackView)

        rootStackView.addArrangedSubviews([
            pointsStackView,
            receiversNumberHeaderTitleLabel,
            receiversNumberTextField,
            pointTypeHeaderTitleLabel,
            chipBar,
            pointAmountHeaderTitleLabel,
            pointAmountTextField,
            pointAmountQuickPickBar,
            giftButton
        ])

        pointsStackView.addArrangedSubviews([pointsView, otherPointsView])
        installContactsButtonOnReceiversTextField()

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            rootStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            rootStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            rootStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            rootStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),

            rootStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),

            chipBar.heightAnchor.constraint(equalToConstant: 28),
            pointAmountQuickPickBar.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    private func installContactsButtonOnReceiversTextField() {
        let rightContainerView = UIView()
        rightContainerView.translatesAutoresizingMaskIntoConstraints = false
        rightContainerView.addSubview(contactsButton)

        NSLayoutConstraint.activate([
            rightContainerView.widthAnchor.constraint(equalToConstant: 44),
            rightContainerView.heightAnchor.constraint(equalToConstant: 44),

            contactsButton.centerYAnchor.constraint(equalTo: rightContainerView.centerYAnchor),
            contactsButton.centerXAnchor.constraint(equalTo: rightContainerView.centerXAnchor)
        ])

        receiversNumberTextField.rightView = rightContainerView
        receiversNumberTextField.rightViewMode = .always
    }

    private func normalizedPhoneNumber(_ string: String) -> String {
        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
        let hasPlusPrefix = trimmedString.hasPrefix("+")
        let digitsOnly = trimmedString.filter { $0.isNumber }.dropLeading88()
        return hasPlusPrefix ? "\(digitsOnly)" : digitsOnly
    }

    // MARK: - Contacts
    @objc private func didTapContactsButton() {
        let contactPickerViewController = CNContactPickerViewController()
        contactPickerViewController.delegate = self
        contactPickerViewController.displayedPropertyKeys = [CNContactPhoneNumbersKey]
        contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        contactPickerViewController.predicateForSelectionOfContact = NSPredicate(value: false)
        present(contactPickerViewController, animated: true)
    }
}

// MARK: - GiftPointViewProtocol
extension GiftPointViewController: GiftPointViewProtocol {

    func setLoading(_ isLoading: Bool) {
        showLoader(isLoading ? .loading : .hidden)
        giftButton.isEnabled = !isLoading
    }

    func showToast(message: String, isError: Bool) {
        Toast.show(message, style: isError ? .error : .success)
    }

    func showUserSummary(_ summary: UserSummaryResponse) {
        if let breakdown = summary.scoreBreakdown, breakdown.count >= 2 {
            pointsView.configure(breakdown[0])
            otherPointsView.configure(breakdown[1])
        }

        let pointBreakdown = summary.scoreBreakdown ?? []
        chipBar.setItems(pointBreakdown, selectedIndex: pointBreakdown.isEmpty ? nil : 0) { item in
            item.walletTitle ?? "Unknown"
        }
        selectedPointBreakdown = chipBar.selectedItem
    }

    func showNotRegisteredAlert() {
        Alert.show(
            AlertConfig(
                title: "নিবন্ধিত নয়",
                message: "প্রাপক নিবন্ধিত নয়। অনুগ্রহ করে সঠিক নম্বর দিন।",
                icon: .lottie(.failed, loop: .loop, speed: 1.0),
                buttons: .ok(title: "ঠিক আছে")
            )
        )
    }

    func showConfirmTransfer(fullName: String, msisdn: String, pointAmount: String, walletTitle: String?) {
        let walletName = walletTitle ?? ""
        let walletLine = walletName.isEmpty ? "" : "\n\(walletName)"

        Alert.show(
            AlertConfig(
                title: "গিফট পয়েন্ট",
                message: "\(fullName)\n\(msisdn)\(walletLine)\nপয়েন্টের পরিমান: \(pointAmount)",
                icon: .lottie(.failed, loop: .loop, speed: 1.0),
                buttons: .yesNo(yesTitle: "নিশ্চিত করুন", noTitle: "বাতিল")
            ),
            onYes: { [weak self] in
                guard let self else { return }
                guard let walletID = self.selectedPointBreakdown?.walletId else { return }
                let amount = Int(pointAmount) ?? 0
                self.presenter?.didConfirmTransfer(receiverMSISDN: msisdn, pointAmount: amount, walletID: walletID)
            },
            onNo: { }
        )
    }

    func showTransferSuccess() {
        Alert.show(
            AlertConfig(
                title: "অভিনন্দন",
                message: "আপনার পয়েন্ট গিফট সফল হয়েছে",
                icon: .lottie(.failed, loop: .loop, speed: 1.0),
                buttons: .ok(title: "ঠিক আছে")
            ),
            onOK: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        )
    }
}

// MARK: - CNContactPickerDelegate
extension GiftPointViewController: CNContactPickerDelegate {
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        guard contactProperty.key == CNContactPhoneNumbersKey,
              let phoneNumber = contactProperty.value as? CNPhoneNumber else { return }

        receiversNumberTextField.text = normalizedPhoneNumber(phoneNumber.stringValue)
    }
}

// MARK: - NavigationBarDelegate
extension GiftPointViewController: NavigationBarDelegate {
    func navBarDidTapBack(in vc: UIViewController) {
        presenter?.didTapBack()
    }
}
//
//// MARK: - GiftPointViewController
//final class GiftPointViewController: UIViewController {
//
//    private let scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.alwaysBounceVertical = true
//        scrollView.showsVerticalScrollIndicator = false
//        return scrollView
//    }()
//
//    private let rootStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .fill
//        stackView.spacing = 16
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//
//    private let pointsStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.alignment = .fill
//        stackView.distribution = .fillEqually
//        stackView.spacing = 8
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//
//    private let pointsView: ScoreBreakdownView = {
//        let view = ScoreBreakdownView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private let otherPointsView: ScoreBreakdownView = {
//        let view = ScoreBreakdownView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//
//    private var receiversNumberHeaderTitleLabel: UILabel = {
//        let label = UILabel()
//        label.text = AppConstants.Profile.GiftPoint.receiversNumberTitle
//        label.textColor = .wcVelvet
//        label.font = .winFont(.semiBold, size: .small)
//        label.textAlignment = .left
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let receiversNumberTextField: WinTextField = {
//        let textField = WinTextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.leftImage = UIImage(systemName: "phone")?.withTintColor(.black)
//        textField.placeholder = AppConstants.Profile.GiftPoint.receiversNumberPlaceholder
//        textField.borderColor = .gray
//        textField.backgroundColor = .white
//        textField.keyboardType = .phonePad
//        return textField
//    }()
//
//    // ✅ NEW: Contacts button (right side inside the textfield)
//    private lazy var contactsButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setImage(UIImage(resource: .contactsBook), for: .normal)
//        button.tintColor = .wcVelvet
//        button.addTarget(self, action: #selector(didTapContactsButton), for: .touchUpInside)
//
//        NSLayoutConstraint.activate([
//            button.widthAnchor.constraint(equalToConstant: 28),
//            button.heightAnchor.constraint(equalToConstant: 28)
//        ])
//        return button
//    }()
//
//    private var pointTypeHeaderTitleLabel: UILabel = {
//        let label = UILabel()
//        label.text = AppConstants.Profile.GiftPoint.pointTypeTitle
//        label.textColor = .wcVelvet
//        label.font = .winFont(.semiBold, size: .small)
//        label.textAlignment = .left
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private lazy var chipBar: SelectableChipBar<PointBreakdown> = {
//        let view = SelectableChipBar<PointBreakdown>()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.onSelectionChanged = { [weak self] selectedPointBreakdown, selectedIndex in
//            print("Selected index:", selectedIndex, "title:", selectedPointBreakdown.walletTitle ?? "")
//            self?.selectedPointBreakdown = selectedPointBreakdown
//        }
//        return view
//    }()
//
//    private var pointAmountHeaderTitleLabel: UILabel = {
//        let label = UILabel()
//        label.text = AppConstants.Profile.GiftPoint.pointAmountTitle
//        label.textColor = .wcVelvet
//        label.font = .winFont(.semiBold, size: .small)
//        label.textAlignment = .left
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let pointAmountTextField: WinTextField = {
//        let textField = WinTextField()
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.leftImage = UIImage(resource: .starCircle)
//        textField.placeholder = AppConstants.Profile.GiftPoint.pointAmountPlaceholder
//        textField.borderColor = .gray
//        textField.backgroundColor = .white
//        textField.keyboardType = .numberPad
//        return textField
//    }()
//
//    private lazy var pointAmountQuickPickBar: PointAmountQuickPickBar = {
//        let view = PointAmountQuickPickBar()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.setValues([100, 200, 300, 400, 500])
//        view.onValueTapped = { [weak self] value in
//            self?.pointAmountTextField.text = "\(value)"
//        }
//        return view
//    }()
//    
//    private let giftButton: WinButton = {
//        let button = WinButton(height: 40, cornerRadius: 20, background: .solid(.wcVelvet))
//        button.font(.winFont(.regular, size: .medium), title: AppConstants.Profile.Invitation.share, color: .white)
//        return button
//    }()
//
//    private let viewModel = GiftPointViewModel()
//    private var selectedPointBreakdown: PointBreakdown?
//
//    init(_ userSummery: UserSummaryResponse? = nil) {
//        if let userSummery {
//            viewModel.userSummary = userSummery
//        } else {
//            viewModel.getUserSummery()
//        }
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//        bindViewModelAndLoad()
//        
//        giftButton.addTarget(self, action: #selector(giftButtonTapped), for: .touchUpInside)
//    }
//
//    @objc private func giftButtonTapped() {
//        viewModel.getReceiverForTransfer(receiversNumberTextField.text ?? "")
//    }
//    
//    private func setupView() {
//        setupNavigationBar(isBackButton: true, delegate: self)
//        view.backgroundColor = .wcBackground
//
//        view.addSubview(scrollView)
//        scrollView.addSubview(rootStackView)
//
//        rootStackView.addArrangedSubviews([
//            pointsStackView,
//            receiversNumberHeaderTitleLabel,
//            receiversNumberTextField,
//            pointTypeHeaderTitleLabel,
//            chipBar,
//            pointAmountHeaderTitleLabel,
//            pointAmountTextField,
//            pointAmountQuickPickBar,
//            giftButton
//        ])
//
//        pointsStackView.addArrangedSubviews([pointsView, otherPointsView])
//
//        // ✅ Put contacts button on the RIGHT side of receiversNumberTextField
//        installContactsButtonOnReceiversTextField()
//
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//
//            rootStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
//            rootStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
//            rootStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
//            rootStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
//
//            rootStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
//
//            chipBar.heightAnchor.constraint(equalToConstant: 28),
//            pointAmountQuickPickBar.heightAnchor.constraint(equalToConstant: 28)
//        ])
//    }
//
//    private func installContactsButtonOnReceiversTextField() {
//        // Container gives padding so button doesn't stick to the edge.
//        let rightContainerView = UIView()
//        rightContainerView.translatesAutoresizingMaskIntoConstraints = false
//        rightContainerView.addSubview(contactsButton)
//
//        NSLayoutConstraint.activate([
//            rightContainerView.widthAnchor.constraint(equalToConstant: 44),
//            rightContainerView.heightAnchor.constraint(equalToConstant: 44),
//
//            contactsButton.centerYAnchor.constraint(equalTo: rightContainerView.centerYAnchor),
//            contactsButton.centerXAnchor.constraint(equalTo: rightContainerView.centerXAnchor)
//        ])
//
//        receiversNumberTextField.rightView = rightContainerView
//        receiversNumberTextField.rightViewMode = .always
//    }
//
//    private func bindViewModelAndLoad() {
//        if let userSummary = viewModel.userSummary {
//            applyUserSummary(userSummary)
//            return
//        }
//
//        viewModel.onUserSummaryUpdated = { [weak self] userSummary in
//            self?.applyUserSummary(userSummary)
//        }
//
////        viewModel.onUserStatusUpdated = { [weak self] userInfo in
////            guard let self else { return }
////
////            // Validate point amount
////            let pointText = self.pointAmountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
////            guard let pointAmount = Int(pointText), pointAmount > 0 else {
////                Toast.show("পয়েন্টের পাইমান দিন", style: .error)
////                return
////            }
////
////            // Validate receiver info
////            guard let msisdn = receiversNumberTextField.text, !msisdn.isEmpty else {
////                Toast.show("পয়েন্ট গ্রাহকের ফোন নম্বর দিন", style: .error)
////                return
////            }
////            guard let walletId = self.selectedPointBreakdown?.walletId else {
////                Toast.show("পয়েন্টের ধারণ সিলেক্ট করুন", style: .error)
////                return
////            }
////
////            // Determine registration status (default to false if unknown)
////            let isRegistered = userInfo.msisdn?.isNotEmpty ?? false
////
////            if !isRegistered {
////                // Show not registered alert
////                Alert.show(
////                    AlertConfig(
////                        title: "নিবন্ধিত নয়",
////                        message: "প্রাপক নিবন্ধিত নয়। অনুগ্রহ করে সঠিক নম্বর দিন।",
////                        icon: .lottie(.failed, loop: .loop, speed: 1.0),
////                        buttons: .ok(title: "ঠিক আছে")
////                    ),
////                    onOK: { }
////                )
////                return
////            } else {
////
////                // Confirm transfer alert for registered user
////                Alert.show(
////                    AlertConfig(
////                        title: "গিফট পয়েন্ট",
////                        message: "\(userInfo.fullName ?? "")\n\(msisdn)\nপয়েন্টের পরিমান: \(pointAmount)",
////                        icon: .lottie(.failed, loop: .loop, speed: 1.0),
////                        buttons: .yesNo(yesTitle: "নিশ্চিত করুন", noTitle: "বাতিল")
////                    ),
////                    onYes: {
////                        let request = PointTransferRequest(
////                            receiverMSISDN: msisdn,
////                            walletID: String(walletId),
////                            pointAmount: String(pointAmount)
////                        )
////                        self.viewModel.transferPoints(request)
////                    },
////                    onNo: { }
////                )
////            }
////        }
//        
//        viewModel.onUserStatusUpdated = { [weak self] userInfo in
//            guard let self else { return }
//            guard let fullName = userInfo.fullName,
//                  let msisdn = userInfo.msisdn else { return }
//            let pointAmount = self.pointAmountTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
////            guard let pointAmount = Int(pointText), pointAmount > 0 else {
////                Toast.show("পয়েন্টের পাইমান দিন", style: .error)
////                return
////            }
//
////            guard let msisdn = receiversNumberTextField.text, !msisdn.isEmpty else {
////                Toast.show("পয়েন্ট গ্রাহকের ফোন নম্বর দিন", style: .error)
////                return
////            }
//
//            guard let walletId = self.selectedPointBreakdown?.walletId else {
//                Toast.show("পয়েন্টের ধরণ সিলেক্ট করুন", style: .error)
//                return
//            }
//
//            let isRegistered = userInfo.msisdn?.isNotEmpty ?? false
//
//            // ❌ NOT REGISTERED
//            if !isRegistered {
//                Alert.show(
//                    AlertConfig(
//                        title: "নিবন্ধিত নয়",
//                        message: "প্রাপক নিবন্ধিত নয়। অনুগ্রহ করে সঠিক নম্বর দিন।",
//                        icon: .lottie(.failed, loop: .loop, speed: 1.0),
//                        buttons: .ok(title: "ঠিক আছে")
//                    )
//                )
//                return
//            }
//
//            // ✅ REGISTERED → PREPARE REQUEST (ONCE)
//            var request: PointTransferRequest? = PointTransferRequest(
//                receiverMSISDN: msisdn,
//                walletID: walletId,
//                pointAmount: Int(pointAmount) ?? 0
//            )
//
//            // ✅ CONFIRM ALERT
//            Alert.show(
//                AlertConfig(
//                    title: "গিফট পয়েন্ট",
//                    message: "\(fullName)\n\(msisdn)\nপয়েন্টের পরিমান: \(pointAmount)",
//                    icon: .lottie(.failed, loop: .loop, speed: 1.0),
//                    buttons: .yesNo(yesTitle: "নিশ্চিত করুন", noTitle: "বাতিল")
//                ),
//                onYes: { [weak self] in
//                    guard let self, let request = request else { return }
//                    self.viewModel.transferPoints(request)
//                },
//                onNo: { [weak self] in
//                    request = nil
//                }
//            )
//        }
//
//        
//        viewModel.onPointTransferUpdated = { [weak self] success in
//            if success {
//                Alert.show(
//                    AlertConfig(
//                        title: "অভিনন্দন",
//                        message: "আপনার পয়েন্ট গিফট সফল হয়েছে",
//                        icon: .lottie(.failed, loop: .loop, speed: 1.0),
//                        buttons: .ok(title: "ঠিক আছে")
//                    ), onOK: {
//                        self?.navigationController?.popViewController(animated: true)
//                    }
//                )
//            }
//        }
//    }
//
//    private func applyUserSummary(_ userSummary: UserSummaryResponse) {
//        if let breakdown = userSummary.scoreBreakdown, breakdown.count >= 2 {
//            pointsView.configure(breakdown[0])
//            otherPointsView.configure(breakdown[1])
//        }
//
//        let pointBreakdown = userSummary.scoreBreakdown ?? []
//
//        chipBar.setItems(pointBreakdown, selectedIndex: pointBreakdown.isEmpty ? nil : 0) { item in
//            item.walletTitle ?? "Unknown"
//        }
//
//        selectedPointBreakdown = chipBar.selectedItem
//    }
//
//    func getSelectedPointBreakdown() -> PointBreakdown? {
//        return chipBar.selectedItem
//    }
//
//    // MARK: - Contacts
//
//    @objc private func didTapContactsButton() {
//        // NOTE: You MUST add "NSContactsUsageDescription" in Info.plist or iOS will crash.
//        let contactPickerViewController = CNContactPickerViewController()
//        contactPickerViewController.delegate = self
//
//        // Show only phone numbers
//        contactPickerViewController.displayedPropertyKeys = [CNContactPhoneNumbersKey]
//        contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
//
//        // Force user to select a phone number (not just a contact card)
//        contactPickerViewController.predicateForSelectionOfContact = NSPredicate(value: false)
//
//        present(contactPickerViewController, animated: true)
//    }
//
//    private func normalizedPhoneNumber(_ string: String) -> String {
//        let trimmedString = string.trimmingCharacters(in: .whitespacesAndNewlines)
//        let hasPlusPrefix = trimmedString.hasPrefix("+")
//        let digitsOnly = trimmedString.filter { $0.isNumber }.dropLeading88()
//        return hasPlusPrefix ? "\(digitsOnly)" : digitsOnly
//    }
//}
//
//// MARK: - CNContactPickerDelegate
//extension GiftPointViewController: CNContactPickerDelegate {
//
//    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
//        guard contactProperty.key == CNContactPhoneNumbersKey,
//              let phoneNumber = contactProperty.value as? CNPhoneNumber else { return }
//
//        let numberString = normalizedPhoneNumber(phoneNumber.stringValue)
//        receiversNumberTextField.text = numberString
//    }
//}
//
//// MARK: - NavigationBarDelegate
//extension GiftPointViewController: NavigationBarDelegate {
//    func navBarDidTapBack(in vc: UIViewController) {
//        vc.navigationController?.popViewController(animated: true)
//    }
//}
//
//
//// MARK: - GiftPointViewModel
//final class GiftPointViewModel {
//
//    var userSummary: UserSummaryResponse?
//    var onUserSummaryUpdated: ((UserSummaryResponse) -> Void)?
//    var onUserStatusUpdated: ((UserInfo) -> Void)?
//    var onPointTransferUpdated: ((Bool) -> Void)?
//
//    private let networkClient: NetworkClient
//
//    init(networkClient: NetworkClient = NetworkClient()) {
//        self.networkClient = networkClient
//    }
//
//    func getUserSummery() {
//        Task { [weak self] in
//            guard let self = self else { return }
//
//            var request = APIRequest(path: APIConstants.userSummeryURL)
//            request.method = .get
//
//            do {
//                let response: APIResponse<UserSummaryResponse> = try await self.networkClient.get(request)
//                await MainActor.run {
//                    if let data = response.data {
//                        self.userSummary = data
//                        self.onUserSummaryUpdated?(data)
//                    } else {
//                        // handle "no data"
//                    }
//                }
//            } catch {
//                await MainActor.run {
//                    // handle error
//                }
//            }
//        }
//    }
//
//    func getReceiverForTransfer(_ msisdn: String) {
//        Task { [weak self] in
//            guard let self = self else { return }
//
//            var request = APIRequest(path: APIConstants.getReceiverForTransferURL(msisdn))
//            request.method = .get
//
//            do {
//                let response: APIResponse<UserInfo> = try await self.networkClient.get(request)
//                await MainActor.run {
//                    guard response.status == 200, let data = response.data else {
//                        
//                        return
//                    }
//                    self.onUserStatusUpdated?(data)
//                    let request = PointTransferRequest(receiverMSISDN: data.msisdn ?? "", walletID: 0, pointAmount: 200)
//                    self.transferPoints(request)
//                }
//            } catch {
//                await MainActor.run {
//                    // handle error
//                }
//            }
//        }
//    }
//    
//    func transferPoints(_ request: PointTransferRequest) {
//        Task { [weak self] in
//            guard let self else { return }
//            
//            let request = [
//                "ReceiverMsisdn": request.receiverMSISDN,
//                "WalletId": String(request.walletID),
//                "PointAmount": String(request.pointAmount),
//            ]
//
//            var req = APIRequest(path: APIConstants.transferPointsURL)
//            req.method = .post
//            req.query = request
//
//            do {
//                let response: APIResponse<Bool> = try await self.networkClient.post(req)
//                await MainActor.run {
//                    guard response.status == 200, response.data == true else { return }
//                    self.onPointTransferUpdated?(response.data!)
//                }
//            } catch {
//                await MainActor.run {
//                    
//                }
//            }
//        }
//    }
//}
//


