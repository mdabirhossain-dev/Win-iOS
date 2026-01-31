//
//
//  StoreViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 20/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - StoreViewController
final class StoreViewController: UIViewController {

    var presenter: StorePresenterProtocol?

    // MARK: - UI
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    private let paymentOptionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.backgroundColor = .white
        stackView.applyCornerRadious(16)
        return stackView
    }()

    private let winImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .winLogoText))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .winFont(.regular, size: .medium)
        label.textColor = .label
        label.text = "পেমেন্ট অপশন বেছে নিন"
        return label
    }()

    private lazy var paymentWalletsCollectionView: UICollectionView = {
        let layout = WrappingFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = .init(top: 0, left: 12, bottom: 12, right: 12)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        return collectionView
    }()

    private lazy var subscriptionPlansCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makePlansLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(
            CollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionViewHeader.className
        )
        return collectionView
    }()

    // MARK: - Wallet chip sizing
    private let walletChipHeight: CGFloat = 44
    private let walletChipHorizontalPadding: CGFloat = 12
    private let walletChipImageSize: CGFloat = 24
    private let walletChipSpacing: CGFloat = 10

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        assert(presenter != nil, "Open via StoreRouter.createModule()")
        setupView()
        setupCollections()
        presenter?.viewDidLoad()
    }

    // MARK: - Setup
    private func setupView() {
        let rightButtons = [NavigationBarButtonConfig(image: UIImage(systemName: "xmark"))]
        setupNavigationBar(rightButtons: rightButtons, isBackButton: false, delegate: self)

        view.backgroundColor = .wcBackground

        view.addSubview(rootStackView)
        rootStackView.addArrangedSubviews([paymentOptionsStackView, subscriptionPlansCollectionView])
        paymentOptionsStackView.addArrangedSubviews([winImageView, titleLabel, paymentWalletsCollectionView])

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            winImageView.heightAnchor.constraint(equalToConstant: 44),
            paymentWalletsCollectionView.heightAnchor.constraint(equalToConstant: 120)
        ])

        subscriptionPlansCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }

    private func setupCollections() {
        paymentWalletsCollectionView.dataSource = self
        paymentWalletsCollectionView.delegate = self
        paymentWalletsCollectionView.register(
            PaymentWalletCollectionViewCell.self,
            forCellWithReuseIdentifier: PaymentWalletCollectionViewCell.className
        )

        subscriptionPlansCollectionView.dataSource = self
        subscriptionPlansCollectionView.delegate = self
        subscriptionPlansCollectionView.register(
            PaymentPlansCollectionViewCell.self,
            forCellWithReuseIdentifier: PaymentPlansCollectionViewCell.className
        )
        subscriptionPlansCollectionView.register(
            CollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionViewHeader.className
        )
    }

    // MARK: - Layout
    private func makePlansLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { _, env in
            let columns = 2
            let insets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 20, trailing: 16)
            let interItemSpacing: CGFloat = 12
            let lineSpacing: CGFloat = 14
            let aspectRatio: CGFloat = 0.95

            let containerW = env.container.effectiveContentSize.width
            let availableW = containerW - insets.leading - insets.trailing
            let totalGaps = CGFloat(columns - 1) * interItemSpacing
            let itemW = (availableW - totalGaps) / CGFloat(columns)
            let itemH = itemW / max(aspectRatio, 0.0001)

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemW),
                heightDimension: .absolute(itemH)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(itemH)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            group.interItemSpacing = .fixed(interItemSpacing)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = insets
            section.interGroupSpacing = lineSpacing

            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: insets.leading, bottom: 10, trailing: insets.trailing)
            section.boundarySupplementaryItems = [header]

            return section
        }
    }
}

// MARK: - NavigationBarDelegate
extension StoreViewController: NavigationBarDelegate {
    func navBar(_ vc: UIViewController, didTapRightButtonAt index: Int) {
        if index == 0 { presenter?.didTapClose() }
    }
}

// MARK: - View Protocol
extension StoreViewController: StoreViewProtocol {

    func setLoading(_ isLoading: Bool) {
        showLoader(isLoading ? .loading : .hidden)
        view.isUserInteractionEnabled = !isLoading
    }

    func reloadWallets() {
        paymentWalletsCollectionView.reloadData()
    }

    func reloadPlans() {
        subscriptionPlansCollectionView.reloadData()
    }

    func showToast(message: String, isError: Bool) {
        Toast.show(message, style: isError ? .error : .success)
    }
}

// MARK: - UICollectionViewDataSource
extension StoreViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView === subscriptionPlansCollectionView {
            return presenter?.planSectionsCount() ?? 0
        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === paymentWalletsCollectionView {
            return presenter?.walletCount() ?? 0
        }
        return presenter?.plansCount(in: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if collectionView === paymentWalletsCollectionView {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PaymentWalletCollectionViewCell.className,
                for: indexPath
            ) as! PaymentWalletCollectionViewCell

            let wallet = presenter?.wallet(at: indexPath.item)
            let isSelected = indexPath.item == (presenter?.selectedWalletIndex() ?? 0)
            cell.configure(title: wallet?.walletTitle, imgURL: wallet?.walletImage, isSelected: isSelected)
            return cell
        }

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PaymentPlansCollectionViewCell.className,
            for: indexPath
        ) as! PaymentPlansCollectionViewCell

        if let plan = presenter?.plan(at: indexPath) {
            cell.configure(plan: plan)
            cell.onTap = { [weak self] in
                self?.presenter?.didTapPlan(at: indexPath)
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard collectionView === subscriptionPlansCollectionView,
              kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CollectionViewHeader.className,
            for: indexPath
        ) as! CollectionViewHeader

        header.showsSeeAll = true
        header.setTitle(presenter?.planSectionTitle(at: indexPath.section) ?? "")
        header.setSeeAllTitle("অটো রিনিউয়াল (+ভ্যাট)", color: .gray)

        return header
    }
}

// MARK: - UICollectionViewDelegate
extension StoreViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard collectionView === paymentWalletsCollectionView else { return }
        presenter?.didSelectWallet(at: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension StoreViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard collectionView === paymentWalletsCollectionView else { return .zero }

        let title = presenter?.wallet(at: indexPath.item)?.walletTitle ?? ""
        let font = UIFont.winFont(.regular, size: .small)
        let textW = (title as NSString).size(withAttributes: [.font: font]).width.rounded(.up)

        let contentW =
        walletChipHorizontalPadding
        + walletChipImageSize
        + walletChipSpacing
        + textW
        + walletChipHorizontalPadding

        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let maxW = collectionView.bounds.width - layout.sectionInset.left - layout.sectionInset.right

        return CGSize(width: min(contentW, maxW), height: walletChipHeight)
    }
}
