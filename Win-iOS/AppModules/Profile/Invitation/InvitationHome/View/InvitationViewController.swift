//
//
//  InvitationViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 29/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class InvitationViewController: UIViewController {

    var presenter: InvitationPresenterProtocol?

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let invitationHeaderRootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.backgroundColor = .wcYellow
        stackView.applyCornerRadious(8)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let invitationImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .invitation))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()

    private let invitationInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 4
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setContentHuggingPriority(.required, for: .vertical)
        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
        return stackView
    }()

    private var invitationHeaderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.Profile.Invitation.invitationHeader
        label.textColor = .wcVelvet
        label.font = .winFont(.bold, size: .large)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var invitationDescriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.Profile.Invitation.invitationDescription
        label.font = .winFont(.regular, size: .small)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var invitationBonusLabel: UILabel = {
        let label = UILabel()
        label.font = .winFont(.semiBold, size: .small)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let inviteHistoryButton: ProfileOptionButton = {
        let button = ProfileOptionButton()
        button.configure(title: "ইনভাইট হিস্ট্রি", imageName: "history")
        button.applyCornerRadious(20)
        return button
    }()

    private var invitationCodeHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = AppConstants.Profile.Invitation.yourInvitationCode
        label.textColor = .wcVelvet
        label.font = .winFont(.semiBold, size: .small)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let invitationCodeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.backgroundColor = .wcPinkLight
        stackView.applyCornerRadious(24)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var invitationCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = .winFont(.regular, size: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var copyInvitationCodeButton: UIButton = {
        let button = UIButton(type: .system)
        button.font(.winFont(.regular, size: .medium), title: AppConstants.Profile.Invitation.copyCode, color: .wcVelvet)
        button.translatesAutoresizingMaskIntoConstraints = false

        let icon = UIImage(systemName: "doc.on.doc")?.withRenderingMode(.alwaysTemplate)
        button.setImage(icon, for: .normal)
        button.tintColor = .wcVelvet
        button.setTitleColor(.wcVelvet, for: .normal)

        button.contentHorizontalAlignment = .trailing
        button.semanticContentAttribute = .forceLeftToRight

        var config = UIButton.Configuration.plain()
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        button.configuration = config

        return button
    }()

    private let shareButton: WinButton = {
        let button = WinButton(height: 40, cornerRadius: 20, background: .solid(.white))
        button.font(.winFont(.regular, size: .medium), title: AppConstants.Profile.Invitation.share, color: .wcVelvet)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.wcVelvet.cgColor
        return button
    }()

    private var currentCode: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        wireActions()
        presenter?.viewDidLoad()
    }

    private func wireActions() {
        inviteHistoryButton.addTarget(self, action: #selector(didTapHistory), for: .touchUpInside)

        copyInvitationCodeButton.bindCopy(
            CopyTextAction(
                textProvider: { [weak self] in self?.currentCode ?? "" },
                onCopied: { _ in
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    Toast.show("কোড কপি হয়েছে", style: .success)
                }
            )
        )

        shareButton.bindShare(
            ShareSheetAction(
                itemsProvider: { [weak self] in
                    guard let self else { return [] }
                    guard let msg = self.presenter?.shareMessage(), !msg.isEmpty else { return [] }
                    return [msg]
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
            invitationHeaderRootStackView,
            inviteHistoryButton,
            invitationCodeHeaderLabel,
            invitationCodeStackView,
            shareButton
        ])

        invitationHeaderRootStackView.addArrangedSubviews([invitationInfoStackView, invitationImageView])
        invitationInfoStackView.addArrangedSubviews([invitationHeaderTitleLabel, invitationDescriptionTitleLabel, invitationBonusLabel])
        invitationCodeStackView.addArrangedSubviews([invitationCodeLabel, copyInvitationCodeButton])

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            rootStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rootStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
            rootStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),

            invitationHeaderRootStackView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            invitationHeaderRootStackView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
        ])
    }

    @objc private func didTapHistory() {
        presenter?.didTapHistory(navigationController: navigationController)
    }
}

// MARK: - InvitationViewProtocol
extension InvitationViewController: InvitationViewProtocol {

    func setLoading(_ isLoading: Bool) {
        showLoader(isLoading ? .loading : .hidden)
    }

    func showToast(message: String, isError: Bool) {
        Toast.show(message, style: isError ? .error : .success)
    }

    func setInvitation(pointsText: String, codeText: String) {
        invitationBonusLabel.text = pointsText

        let raw = presenter?.invitationCodeText() ?? ""
        currentCode = raw
        invitationCodeLabel.text = codeText
    }

    func setInvitationUIVisible(_ isVisible: Bool) {
        invitationCodeHeaderLabel.isHidden = !isVisible
        invitationCodeStackView.isHidden = !isVisible
        shareButton.isHidden = !isVisible
    }
}

// MARK: - NavigationBarDelegate
extension InvitationViewController: NavigationBarDelegate {
    func navBarDidTapBack(in vc: UIViewController) {
        vc.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Button that looks EXACTLY like the cell (hosts same row view)
final class ProfileOptionButton: UIButton {

    private let rowView = ProfileOptionRowView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        // Make UIButton not fight with the hosted view
        setTitle(nil, for: .normal)
        setImage(nil, for: .normal)
        backgroundColor = .clear

        addSubview(rowView)
        rowView.translatesAutoresizingMaskIntoConstraints = false
        rowView.isUserInteractionEnabled = false // IMPORTANT: so taps go to the button

        NSLayoutConstraint.activate([
            rowView.topAnchor.constraint(equalTo: topAnchor),
            rowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            rowView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rowView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    func configure(title: String, imageName: String) {
        rowView.configure(title: title, imageName: imageName)
        accessibilityLabel = title
        accessibilityTraits = .button
    }

    override var isHighlighted: Bool {
        didSet {
            // simple press feedback
            rowView.alpha = isHighlighted ? 0.65 : 1.0
            transform = isHighlighted ? CGAffineTransform(scaleX: 0.99, y: 0.99) : .identity
        }
    }
}


//class InvitationViewController: UIViewController {
//    
//    private let scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        return scrollView
//    }()
//    
//    private let rootStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.spacing = 20
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//    
//    private let invitationHeaderRootStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.alignment = .center
//        stackView.spacing = 12
//        stackView.backgroundColor = .wcYellow
//        stackView.applyCornerRadious(8)
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//    private let invitationImageView: UIImageView = {
//        let imageView = UIImageView(image: UIImage(resource: .invitation))
//        imageView.contentMode = .scaleAspectFit
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.setContentHuggingPriority(.required, for: .horizontal)
//        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
//        return imageView
//    }()
//    private let invitationInfoStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .leading
//        stackView.spacing = 4
//        stackView.distribution = .fill
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//        // prevent vertical stretching
//        stackView.setContentHuggingPriority(.required, for: .vertical)
//        stackView.setContentCompressionResistancePriority(.required, for: .vertical)
//
//        return stackView
//    }()
//    private var invitationHeaderTitleLabel: UILabel = {
//        let label = UILabel()
//        label.text = AppConstants.Profile.Invitation.invitationHeader
//        label.textColor = .wcVelvet
//        label.font = .winFont(.bold, size: .large)
//        label.textAlignment = .left
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    private var invitationDescriptionTitleLabel: UILabel = {
//        let label = UILabel()
//        label.text = AppConstants.Profile.Invitation.invitationDescription
//        label.font = .winFont(.regular, size: .small)
//        label.textAlignment = .left
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    private var invitationBonusLabel: UILabel = {
//        let label = UILabel()
//        label.font = .winFont(.semiBold, size: .small)
//        label.textAlignment = .left
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let inviteHistoryButton: ProfileOptionButton = {
//        let button = ProfileOptionButton()
//        button.configure(title: "ইনভাইট হিস্ট্রি", imageName: "history")
//        button.applyCornerRadious(20)
//        return button
//    }()
//    
//    private var invitationCodeHeaderLabel: UILabel = {
//        let label = UILabel()
//        label.text = AppConstants.Profile.Invitation.yourInvitationCode
//        label.textColor = .wcVelvet
//        label.font = .winFont(.semiBold, size: .small)
//        label.textAlignment = .left
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let invitationCodeStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.alignment = .center
//        stackView.spacing = 12
//        stackView.backgroundColor = .wcPinkLight
//        stackView.applyCornerRadious(24)
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//    private var invitationCodeLabel: UILabel = {
//        let label = UILabel()
//        label.textColor = .black
//        label.textAlignment = .left
//        label.font = .winFont(.regular, size: .medium)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    private var copyInvitationCodeButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.font(.winFont(.regular, size: .medium), title: AppConstants.Profile.Invitation.copyCode, color: .wcVelvet)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        
//        let icon = UIImage(systemName: "doc.on.doc")?.withRenderingMode(.alwaysTemplate)
//        button.setImage(icon, for: .normal)
//        button.tintColor = .wcVelvet
//        button.setTitleColor(.wcVelvet, for: .normal)
//
//        // Layout: image left, text right
//        button.contentHorizontalAlignment = .trailing
//        button.semanticContentAttribute = .forceLeftToRight
//        
//        var config = UIButton.Configuration.plain()
//        config.imagePlacement = .leading
//        config.imagePadding = 8
//        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
//        button.configuration = config
//        
//        return button
//    }()
//    
//    private let shareButton: WinButton = {
//        let button = WinButton(height: 40, cornerRadius: 20, background: .solid(.white))
//        button.font(.winFont(.regular, size: .medium), title: AppConstants.Profile.Invitation.share, color: .wcVelvet)
//        button.layer.borderWidth = 1
//        button.layer.borderColor = UIColor.wcVelvet.cgColor
//        return button
//    }()
//    
//    private let viewModel = InvitationViewModel()
//    
//    private var invitationCodeText: String {
//        viewModel.invitationResponse?.invitationCode ?? ""
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//        wireActions()
//        
//        viewModel.getInvitationInfo { [weak self] result in
//            guard let self else { return }
//            switch result {
//            case .success:
//                self.invitationBonusLabel.text = "\(self.viewModel.invitationResponse?.point?.toBanglaNumberWithSuffix() ?? "০") পয়েন্ট"
//                self.invitationCodeLabel.text = "  \(self.invitationCodeText)"
//            case .failure(let error):
//                // do whatever your app uses (toast/alert/log)
//                print("Invitation API failed:", error.localizedDescription)
//            }
//        }
//    }
//    
//    private func wireActions() {
//        copyInvitationCodeButton.bindCopy(
//            CopyTextAction(
//                textProvider: { [weak self] in self?.invitationCodeText ?? "" },
//                onCopied: { _ in
//                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
//                    Toast.show("কোড কপি হয়েছে", style: .success)
//                }
//            )
//        )
//        
//        // Share
//        shareButton.bindShare(
//            ShareSheetAction(
//                itemsProvider: { [weak self] in
//                    guard let self else { return [] }
//                    let code = self.invitationCodeText.trimmingCharacters(in: .whitespacesAndNewlines)
//                    guard !code.isEmpty else { return [] }
//                    return ["আমার কোড ব্যবহার করে Win এ সাইন আপ করুন। কুইজ খেলে জিতে নিতে পারেন ক্যাশব্যাক। Code: \(code) Link: \(APIConstants.winWebHomeURL)"]
//                }
//            ),
//            presenter: self
//        )
//        
//        inviteHistoryButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
//    }
//    
//    
//    func setupView() {
//        setupNavigationBar(isBackButton: true, delegate: self)
//        
//        view.backgroundColor = .wcBackground
//        
//        view.addSubview(scrollView)
//        scrollView.addSubview(rootStackView)
//        rootStackView.addArrangedSubviews([invitationHeaderRootStackView, inviteHistoryButton, invitationCodeHeaderLabel, invitationCodeStackView, shareButton])
//        invitationHeaderRootStackView.addArrangedSubviews([invitationInfoStackView, invitationImageView])
//        invitationInfoStackView.addArrangedSubviews([invitationHeaderTitleLabel, invitationDescriptionTitleLabel, invitationBonusLabel])
//        
//        invitationCodeStackView.addArrangedSubviews([invitationCodeLabel, copyInvitationCodeButton])
//        
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//            
//            rootStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            rootStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            rootStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8),
//            rootStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8),
//            
//            invitationHeaderRootStackView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
//            invitationHeaderRootStackView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
//        ])
//    }
//    
//    @objc private func didTapButton() {
//        navigationController?.pushViewController(.invitationHistory)
//    }
//}
//
//// MARK: - NavigationBarDelegate
//extension InvitationViewController: NavigationBarDelegate {
//    func navBarDidTapBack(in vc: UIViewController) {
//        vc.navigationController?.popViewController(animated: true)
//    }
//}
//
//
//class InvitationViewModel {
//    private(set) var invitationResponse: InvitationResponse?
//    private let networkClient: NetworkClient
//    
//    init(networkClient: NetworkClient = NetworkClient()) {
//        self.networkClient = networkClient
//    }
//    
//    func getInvitationInfo(completion: @escaping (Result<Bool, Error>) -> Void) {
//        Task { [weak self] in
//            guard let self = self else { return }
//            
//            var req = APIRequest(path: APIConstants.invitationCodeURL)
//            req.method = .get
//            do {
//                let response: APIResponse<InvitationResponse> = try await self.networkClient.get(req)
//                await MainActor.run {
//                    if let data = response.data {
//                        // store response
//                        self.invitationResponse = data
//                        completion(.success(true))
//                    } else {
//                        let error = NSError(domain: "InvitationInteractorError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])
//                        completion(.failure(error))
//                    }
//                }
//            } catch {
//                await MainActor.run {
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//}

