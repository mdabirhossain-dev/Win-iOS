//
//
//  HomePointTransferTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 17/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

protocol HomePointTransferTableViewCellDelegate: AnyObject {
    func pointTransferCell(_ cell: HomePointTransferTableViewCell, didTapButtonAt index: Int, item: PointTransferDetail)
    func pointTransferCell(_ cell: HomePointTransferTableViewCell, didSelectItemAt index: Int, item: PointTransferDetail)
}

class HomePointTransferTableViewCell: UITableViewCell {
    
    weak var delegate: HomePointTransferTableViewCellDelegate?
    
    // MARK: - UI
    private var collectionHeightConstraint: NSLayoutConstraint?
    
    private lazy var collectionView: UICollectionView = {
        let layout = CollectionLayoutFactory.makeLayout([
            .grid(
                columns: 2,
                aspectRatio: 1.0, // square cells
                contentInsets: .init(top: 12, leading: 16, bottom: 12, trailing: 16),
                interItemSpacing: 12,
                lineSpacing: 12
            )
        ])
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsVerticalScrollIndicator = false
        cv.isScrollEnabled = false // important: let table handle scrolling
        cv.dataSource = self
        cv.delegate = self
        cv.register(HomeGridItemsCollectionViewCell.self,
                    forCellWithReuseIdentifier: HomeGridItemsCollectionViewCell.className)
        return cv
    }()
    
    private var pointTransferDetails: [PointTransferDetail] = []
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        contentView.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1)
        collectionHeightConstraint?.priority = .defaultHigh
        collectionHeightConstraint?.isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionHeightIfNeeded()
    }
    
    private func updateCollectionHeightIfNeeded() {
        // Force layout to get correct contentSize
        collectionView.layoutIfNeeded()
        let height = collectionView.collectionViewLayout.collectionViewContentSize.height
        if abs((collectionHeightConstraint?.constant ?? 0) - height) > 1 {
            collectionHeightConstraint?.constant = height
        }
    }
    
    // MARK: - Public API
    
    func configure(_ pointTransferDetails: [PointTransferDetail]) {
        self.pointTransferDetails = pointTransferDetails
        collectionView.reloadData()
        setNeedsLayout()
        layoutIfNeeded()
        updateCollectionHeightIfNeeded()
    }
}

// MARK: - UICollectionViewDataSource

extension HomePointTransferTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        pointTransferDetails.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeGridItemsCollectionViewCell.className,
            for: indexPath
        ) as! HomeGridItemsCollectionViewCell
        
        let pointTransferDetail = pointTransferDetails[indexPath.item]
        cell.configure(title: pointTransferDetail.title ?? "", imgURL: pointTransferDetail.image)
        cell.setButtonTitle(title: pointTransferDetail.buttonTitle ?? "")
        cell.onButtonTap = { [weak self] in
                guard let self else { return }
                delegate?.pointTransferCell(self, didTapButtonAt: indexPath.item, item: pointTransferDetail)
            }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomePointTransferTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = pointTransferDetails[indexPath.item]
        delegate?.pointTransferCell(self, didSelectItemAt: indexPath.item, item: item)
    }
}

final class HomeGridItemsCollectionViewCell: UICollectionViewCell {

    // MARK: - Callbacks
    var onButtonTap: (() -> Void)?

    // MARK: - UI
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.font(.winFont(.semiBold, size: .medium), title: "খেলুন", color: .white)
        button.backgroundColor = .wcVelvet
        button.applyCornerRadious(16)
        button.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()

    private let contentPadding: UIEdgeInsets = .init(top: 12, left: 12, bottom: 12, right: 12)

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupView() {
        backgroundColor = .white
        applyCornerRadious(16)
        applyShadow()

        contentView.addSubview(stackView)
        stackView.addArrangedSubviews([imageView, titleLabel, actionButton])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: contentPadding.top),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: contentPadding.left),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -contentPadding.right),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentPadding.bottom),

            // ✅ image height = half of cell width (stable, no updates needed)
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),

            // ✅ keep label full width while stack is centered
            titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),

            // ✅ button height only; width comes from title + insets
            actionButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    private func setupActions() {
        actionButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
        onButtonTap = nil
    }

    // MARK: - Configure
    func configure(title: String, imgURL: String?) {
        titleLabel.text = title
        if let imgURL = imgURL, imgURL.isNotEmpty {
            imageView.setImage(from: imgURL)
        }
    }

    func setButtonTitle(title: String) {
        actionButton.font(.winFont(.semiBold, size: .medium), title: title, color: .white)

        // If your helper resets insets, keep this:
        actionButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)
    }

    // MARK: - Actions
    @objc private func didTapButton() {
        onButtonTap?()
    }
}
