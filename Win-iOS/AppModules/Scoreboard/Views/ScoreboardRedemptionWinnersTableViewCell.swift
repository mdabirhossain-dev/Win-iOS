//
//
//  ScoreboardRedemptionWinnersTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 30/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

class ScoreboardRedemptionWinnersTableViewCell: UITableViewCell {
    
    // MARK: - UI
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private let headerView: SectionHeaderView = {
        let header = SectionHeaderView()
        header.setTitle("রিডিমপশন বিজয়ীরা")
        return header
    }()
    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.applyGradient(colors: [.wcPinkLight, .white, .wcPinkLight], direction: .vertical, cornerRadius: 8)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // inside padding
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        return stackView
    }()
    
    private let totalRedemptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .winFont(.regular, size: .small)
        label.setImage(UIImage(resource: .giftboxOpen), text: "সর্বমোট রিডিমপশন")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalRedemptionUsersAndStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.backgroundColor = .white
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        stackView.applyCornerRadious(8)
        stackView.applyShadow()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let totalRedemedUserLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .winFont(.regular, size: .small)
        label.setImage(UIImage(systemName: "person.fill"), text: "55 জন")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalRedemedAmountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .wcVelvet
        label.font = .winFont(.semiBold, size: .small)
        label.setImage(UIImage(resource: .takaCircle), text: "৫৭৪২৮০০")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var redeemptionWinerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = false
        collectionView.register(
            ScoreboardRedemptionWinnersInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: ScoreboardRedemptionWinnersInfoCollectionViewCell.className
        )
        return collectionView
    }()
    
    private let redeemScoreButton: WinButton = {
        let button = WinButton(textColor: .wcYellow)
        button.setTitle("স্কোর রিডিম করুন", for: .normal)
        button.setImage(UIImage(resource: .starYellow3D), for: .normal)
        button.setGradientBackground(colors: [.wcVelvet, .wcPink], direction: .horizontal)
        return button
    }()
    
    // MARK: - Data & infinite config
    /// How many times to repeat the base data to fake "infinite" scroll.
    private let repeatCount = 50
    
    /// Raw number of leaderboard items.
    private var baseCount: Int {
        return redemptionLeaderboard?.redemptionLeaderboardItems?.count ?? 0
    }
    
    /// Total items the collection view thinks it has.
    private var totalItems: Int {
        return baseCount * repeatCount
    }
    
    /// Middle index in the repeated space.
    private var middleIndex: Int {
        guard totalItems > 0 else { return 0 }
        return totalItems / 2
    }
    
    private var didSetInitialIndex = false
    
    // MARK: - Auto scroll (smooth)
    private var displayLink: CADisplayLink?
    private var isUserInteracting = false
    private let autoScrollSpeed: CGFloat = 80.0 // points per second
    
    private var redemptionLeaderboard: RedemptionLeaderboard?
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopAutoScrolling()
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Ensure initial positioning & auto-scroll start after we have bounds and data
        if !didSetInitialIndex,
           redeemptionWinerCollectionView.bounds.width > 0,
           totalItems > 0 {
            didSetInitialIndex = true
            
            let mid = middleIndex
            if mid < totalItems {
                let indexPath = IndexPath(item: mid, section: 0)
                redeemptionWinerCollectionView.scrollToItem(
                    at: indexPath,
                    at: .centeredHorizontally,
                    animated: false
                )
            }
            
            startAutoScrolling()
        }
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .clear
        redeemScoreButton.addTarget(self, action: #selector(redeemScoreButtonAction), for: .touchUpInside)
        
        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubviews([headerView, infoStackView])
        infoStackView.addArrangedSubviews([
            totalRedemptionLabel,
            totalRedemptionUsersAndStackView,
            redeemptionWinerCollectionView,
            redeemScoreButton
        ])
        totalRedemptionUsersAndStackView.addArrangedSubviews([
            totalRedemedUserLabel,
            totalRedemedAmountLabel
        ])
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            redeemptionWinerCollectionView.heightAnchor.constraint(equalToConstant: 120),

            redeemScoreButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - Auto Scroll (CADisplayLink)
    private func startAutoScrolling() {
        guard baseCount > 0, totalItems > 0 else { return }
        stopAutoScrolling()
        
        let link = CADisplayLink(target: self, selector: #selector(handleDisplayLink(_:)))
        link.add(to: .main, forMode: .common)
        displayLink = link
    }
    
    private func stopAutoScrolling() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func handleDisplayLink(_ link: CADisplayLink) {
        if isUserInteracting { return }
        guard baseCount > 0, totalItems > 0 else { return }
        guard redeemptionWinerCollectionView.bounds.width > 0 else { return }
        guard redeemptionWinerCollectionView.contentSize.width > redeemptionWinerCollectionView.bounds.width else { return }
        
        let delta = autoScrollSpeed * CGFloat(link.duration)
        
        var newOffsetX = redeemptionWinerCollectionView.contentOffset.x + delta
        let maxOffsetX = redeemptionWinerCollectionView.contentSize.width - redeemptionWinerCollectionView.bounds.width
        
        let threshold = redeemptionWinerCollectionView.bounds.width
        
        if newOffsetX < threshold || newOffsetX > maxOffsetX - threshold {
            recenterAroundMiddle()
            newOffsetX = redeemptionWinerCollectionView.contentOffset.x + delta
        }
        
        redeemptionWinerCollectionView.contentOffset = CGPoint(x: newOffsetX, y: 0)
    }
    
    /// Recenters the collectionView to the middle loop, preserving visually the same logical item.
    private func recenterAroundMiddle() {
        let collectionView = redeemptionWinerCollectionView
        
        guard baseCount > 0, totalItems > 0 else { return }
        
        let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2
        let centerPoint = CGPoint(x: centerX, y: collectionView.bounds.midY)
        
        if let currentIndexPath = collectionView.indexPathForItem(at: centerPoint) {
            let realIndex = currentIndexPath.item % baseCount
            var newIndex = middleIndex + realIndex
            
            if newIndex >= totalItems {
                newIndex = newIndex % totalItems
            }
            
            let newIndexPath = IndexPath(item: newIndex, section: 0)
            collectionView.scrollToItem(at: newIndexPath, at: .centeredHorizontally, animated: false)
        } else {
            let mid = max(0, min(middleIndex, max(totalItems - 1, 0)))
            let midIndexPath = IndexPath(item: mid, section: 0)
            collectionView.scrollToItem(at: midIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    // MARK: - Actions
    @objc private func redeemScoreButtonAction() {
        // hook into delegate / closure if needed
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        isUserInteracting = false
        didSetInitialIndex = false
        stopAutoScrolling()
        redeemptionWinerCollectionView.setContentOffset(.zero, animated: false)
    }
    
    // MARK: - Public configure
    func configure(_ redemptionLeaderboard: RedemptionLeaderboard?) {
        self.redemptionLeaderboard = redemptionLeaderboard
        
        totalRedemedUserLabel.setImage(UIImage(systemName: "person.fill"), text: "\(redemptionLeaderboard?.redemptionCount ?? 0) জন".toBanglaNumberWithSuffix())
        totalRedemedAmountLabel.setImage(UIImage(resource: .takaCircle), text: "\(redemptionLeaderboard?.totalRedeemAmount ?? 0)".toBanglaNumberWithSuffix())
        
        didSetInitialIndex = false
        isUserInteracting = false
        
        redeemptionWinerCollectionView.reloadData()
        // layoutSubviews will handle initial centering & auto-scroll
    }
}

// MARK: - CollectionView
extension ScoreboardRedemptionWinnersTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ScoreboardRedemptionWinnersInfoCollectionViewCell.className,
            for: indexPath
        ) as! ScoreboardRedemptionWinnersInfoCollectionViewCell
        
        guard baseCount > 0 else {
            return cell
        }
        
        let realIndex = indexPath.item % baseCount
        
        if let data = redemptionLeaderboard?.redemptionLeaderboardItems?[realIndex] {
            cell.configure(data)
        }
        
        return cell
    }
    
    // Exactly 3 items visible horizontally
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let sectionInsets = flowLayout?.sectionInset ?? .zero
        let spacing = flowLayout?.minimumInteritemSpacing ?? 10
        
        let itemsPerRow: CGFloat = 3
        let totalHorizontalInsets = sectionInsets.left + sectionInsets.right
        let totalSpacing = spacing * (itemsPerRow - 1)
        let availableWidth = collectionView.bounds.width - totalHorizontalInsets - totalSpacing
        let itemWidth = floor(availableWidth / itemsPerRow)
        
        let itemHeight: CGFloat = 120
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // MARK: - UIScrollViewDelegate (touch vs auto-scroll)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserInteracting = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            isUserInteracting = false
            recenterIfNearEdge()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isUserInteracting = false
        recenterIfNearEdge()
    }
    
    private func recenterIfNearEdge() {
        let cv = redeemptionWinerCollectionView
        let offsetX = cv.contentOffset.x
        let maxOffsetX = cv.contentSize.width - cv.bounds.width
        let threshold = cv.bounds.width
        
        if offsetX < threshold || offsetX > maxOffsetX - threshold {
            recenterAroundMiddle()
        }
    }
}

// MARK: - Item Cell
final class ScoreboardRedemptionWinnersInfoCollectionViewCell: UICollectionViewCell {

    private let rootStackView: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.alignment = .center
        s.distribution = .fill
        s.spacing = 8
        s.isLayoutMarginsRelativeArrangement = true
        s.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false

        // ✅ border + corner + clipping
        iv.applyCornerRadious(28, borderWidth: 2, borderColor: .gray)

        return iv
    }()

    // ✅ star badge sits half outside => must NOT be inside avatarImageView
    private let rankBadgeImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(resource: .starGrayGradient))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let serialNumberLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.textColor = .white
        l.font = .winFont(.semiBold, size: .extraSmall)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let userMSISDNLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = .winFont(.semiBold, size: .small)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let redeemedAmountLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.textColor = .wcVelvet
        l.font = .winFont(.semiBold, size: .small)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.backgroundColor = .clear
        contentView.applyCornerRadious(8)
        contentView.applyShadow()

        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubviews([
            avatarImageView,
            userMSISDNLabel,
            redeemedAmountLabel
        ])

        // ✅ overlay badge + label on contentView so it can extend outside avatar
        contentView.addSubview(rankBadgeImageView)
        rankBadgeImageView.addSubview(serialNumberLabel)

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            avatarImageView.widthAnchor.constraint(equalToConstant: 56),
            avatarImageView.heightAnchor.constraint(equalToConstant: 56),

            // ✅ badge half inside, half outside:
            // Place badge centerX aligned with avatar, and its centerY at avatar bottom edge.
            rankBadgeImageView.centerXAnchor.constraint(equalTo: avatarImageView.centerXAnchor),
            rankBadgeImageView.centerYAnchor.constraint(equalTo: avatarImageView.bottomAnchor),
            rankBadgeImageView.widthAnchor.constraint(equalToConstant: 24),
            rankBadgeImageView.heightAnchor.constraint(equalToConstant: 24),

            // label centered on badge
            serialNumberLabel.centerXAnchor.constraint(equalTo: rankBadgeImageView.centerXAnchor),
            serialNumberLabel.centerYAnchor.constraint(equalTo: rankBadgeImageView.centerYAnchor),

            userMSISDNLabel.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            userMSISDNLabel.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),

            redeemedAmountLabel.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            redeemedAmountLabel.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
        ])
    }

    func configure(_ item: RedemptionLeaderboardItem) {
        avatarImageView.setImage(from: item.userAvatar ?? "")
        userMSISDNLabel.text = item.msisdn?.toBanglaNumberWithSuffix().dropLeading88()
        redeemedAmountLabel.text = "৳\(item.redeemAmount ?? 0)".toBanglaNumberWithSuffix()
        serialNumberLabel.text = "\(item.userRank ?? 0)".toBanglaNumberWithSuffix()
    }
}


//final class ScoreboardRedemptionWinnersInfoCollectionViewCell: UICollectionViewCell {
//
//    private let rootStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .center
//        stackView.distribution = .fill
//        stackView.spacing = 8
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//
//    private let avatarImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFit
//        imageView.applyCornerRadious(28)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
//
//    private let userMSISDNLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.font = .winFont(.semiBold, size: .small)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    private let redeemedAmountLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.textColor = .wcVelvet
//        label.font = .winFont(.semiBold, size: .small)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func setupView() {
//        contentView.backgroundColor = .clear
//        contentView.applyCornerRadious(8)
//        contentView.applyShadow()
//
//        contentView.addSubview(rootStackView)
//        rootStackView.addArrangedSubviews([
//            avatarImageView,
//            userMSISDNLabel,
//            redeemedAmountLabel
//        ])
//
//        NSLayoutConstraint.activate([
//            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//
//            avatarImageView.widthAnchor.constraint(equalToConstant: 56),
//            avatarImageView.heightAnchor.constraint(equalToConstant: 56),
//
//            userMSISDNLabel.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
//            userMSISDNLabel.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),
//
//            redeemedAmountLabel.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
//            redeemedAmountLabel.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor)
//        ])
//    }
//
//    func configure(_ item: RedemptionLeaderboardItem) {
//        avatarImageView.setImage(from: item.userAvatar ?? "")
//        userMSISDNLabel.text = item.msisdn?.toBanglaNumberWithSuffix().dropLeading88()
//        redeemedAmountLabel.text = "৳\(item.redeemAmount ?? 0)".toBanglaNumberWithSuffix()
//    }
//}
