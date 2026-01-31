//
//
//  RequestPointViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

class RequestPointViewController: UIViewController {
    
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
    
    private var receiversNumberHeaderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.Profile.RequestPoint.senderNumberTitle
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
        textField.rightImage = UIImage(resource: .success)
        textField.placeholder = KeychainManager.shared.msisdn.dropLeading88().toBanglaNumberWithSuffix()
        textField.borderColor = .gray
        textField.backgroundColor = .white
        textField.isUserInteractionEnabled = false
        return textField
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
        view.onSelectionChanged = { [weak self] selectedPointBreakdown, selectedIndex in
            Log.info("Selected index: \(selectedIndex), title: \(selectedPointBreakdown.walletTitle ?? "")")
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
    
    private var noteHeaderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.Profile.RequestPoint.noteTitle
        label.textColor = .wcVelvet
        label.font = .winFont(.semiBold, size: .small)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let noteTextView: WinTextView = {
        let textView = WinTextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.placeholder = AppConstants.Profile.RequestPoint.notePlaceholder
        textView.textContainer.lineFragmentPadding = 0
        textView.borderColor = .gray
        return textView
    }()
    
    private let shareButton: WinButton = {
        let button = WinButton(height: 40, cornerRadius: 20, background: .solid(.wcVelvet))
        button.font(.winFont(.regular, size: .medium), title: AppConstants.Profile.Invitation.share, color: .white)
        return button
    }()
    
    private let viewModel = RequestPointViewModel()
    
    private let noteInputLimiter = InputLimiter(maxLength: 500)
    
    init(_ userSummery: UserSummaryResponse? = nil) {
        if let userSummery {
            viewModel.userSummary = userSummery
        } else {
            viewModel.getUserSummery()
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModelAndLoad()
        
        shareButton.bindShare(
            ShareSheetAction(
                itemsProvider: { [weak self] in
                    guard let self else { return [] }
                    let receiversNumber = KeychainManager.shared.msisdn.dropLeading88()
                    guard let pointAmount = self.pointAmountTextField.text, pointAmount.isNotEmpty else {
                        Toast.show("পয়েন্টের পরিমাণ দিন", style: .error)
                        return []
                    }
                    return ["কুইজ খেলতে আমার পয়েন্ট প্রয়োজন। লিঙ্ক এ ক্লিক করে আমাকে পয়েন্ট দেয়ার জন্য অনুরোধ করছি।\n\(self.noteTextView.text ?? "")\n\(APIConstants.requestPointShareURL(receiversNumber: receiversNumber, pointAmount: pointAmount))"]
                }
            ),
            presenter: self
        )
    }
    
    private func setupView() {
        setupNavigationBar(isBackButton: true, delegate: self)
        view.backgroundColor = .wcBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(rootStackView)
        
        rootStackView.addArrangedSubviews([
            receiversNumberHeaderTitleLabel,
            receiversNumberTextField,
            pointTypeHeaderTitleLabel,
            chipBar,
            pointAmountHeaderTitleLabel,
            pointAmountTextField,
            pointAmountQuickPickBar,
            noteHeaderTitleLabel,
            noteTextView,
            shareButton
        ])
        
        noteTextView.delegate = noteInputLimiter
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            rootStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            rootStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -16),
            rootStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -32),
            
            chipBar.heightAnchor.constraint(equalToConstant: 28),
            pointAmountQuickPickBar.heightAnchor.constraint(equalToConstant: 28),
            
            noteTextView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
            noteTextView.heightAnchor.constraint(equalToConstant: 120),
        ])
    }
    
    private func bindViewModelAndLoad() {
        if let userSummary = viewModel.userSummary {
            applyUserSummary(userSummary)
            return
        }
        
        viewModel.onUserSummaryUpdated = { [weak self] userSummary in
            self?.applyUserSummary(userSummary)
        }
    }
    
    private func applyUserSummary(_ userSummary: UserSummaryResponse) {
        let pointBreakdown = userSummary.scoreBreakdown ?? []
        
        chipBar.setItems(pointBreakdown, selectedIndex: pointBreakdown.isEmpty ? nil : 0) { item in
            item.walletTitle ?? "Unknown"
        }
    }
    
    func getSelectedPointBreakdown() -> PointBreakdown? {
        return chipBar.selectedItem
    }
}

// MARK: - NavigationBarDelegate
extension RequestPointViewController: NavigationBarDelegate {
    func navBarDidTapBack(in vc: UIViewController) {
        vc.navigationController?.popViewController(animated: true)
    }
}


// MARK: - GiftPointViewModel

final class RequestPointViewModel {
    
    var userSummary: UserSummaryResponse?
    var onUserSummaryUpdated: ((UserSummaryResponse) -> Void)?
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }
    
    func getUserSummery() {
        Task { [weak self] in
            guard let self = self else { return }
            
            var request = APIRequest(path: APIConstants.userSummeryURL)
            request.method = .get
            
            do {
                let response: APIResponse<UserSummaryResponse> = try await self.networkClient.get(request)
                await MainActor.run {
                    if let data = response.data {
                        self.userSummary = data
                        self.onUserSummaryUpdated?(data)
                    } else {
                        // handle "no data"
                    }
                }
            } catch {
                await MainActor.run {
                    // handle error
                }
            }
        }
    }
}
