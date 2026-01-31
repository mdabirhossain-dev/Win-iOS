//
//
//  HomeTicTacToeTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

class HomeTicTacToeTableViewCell: UITableViewCell {
    
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
        header.setTitle("টিক ট্যাক টো")
        header.showsSeeAll = true
        return header
    }()
    
    private var collectionHeightConstraint: NSLayoutConstraint?
    
    private lazy var collectionView: UICollectionView = {
        let layout = CollectionLayoutFactory.makeLayout([
            .grid(
                columns: 3,
                aspectRatio: 1, // square cells
                contentInsets: .init(top: 12, leading: 16, bottom: 12, trailing: 16),
                interItemSpacing: 12,
                lineSpacing: 12
            )
        ])
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TicTacToeCollectionViewCell.self,
                    forCellWithReuseIdentifier: TicTacToeCollectionViewCell.className)
        return collectionView
    }()
    
    private var ticTacToeData: [TicTacToeData] = []
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubviews([headerView, collectionView])
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
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
    
    func configure(_ ticTacToeData: [TicTacToeData]) {
        self.ticTacToeData = ticTacToeData
        collectionView.reloadData()
        setNeedsLayout()
        layoutIfNeeded()
        updateCollectionHeightIfNeeded()
    }
}

// MARK: - UICollectionViewDataSource

extension HomeTicTacToeTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ticTacToeData.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TicTacToeCollectionViewCell.className,
            for: indexPath
        ) as! TicTacToeCollectionViewCell
        
        let ticTacToe = ticTacToeData[indexPath.item]
        let title = ticTacToe.featureTitle ?? ""
        let gradient = TictacToeGradients.byIndex(indexPath.item)
        cell.configure(title: title, imgURL: ticTacToe.featureImage, gradient: gradient)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeTicTacToeTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ticTacToeData = ticTacToeData[indexPath.item]
        print("Selected:", ticTacToeData.featureTitle)
    }
}

enum TictacToeGradients: CaseIterable {
    case random
    case computer
    case friend

    var colors: [UIColor] {
        switch self {
        case .random: return [.wcCornflowerBlueLight, .wcOrchidPink]
        case .computer: return [.wcSalmonPink, .wcPastelYellow]
        case .friend: return [.wcLightGreen, .wcBabyBlue]
        }
    }

    static func byIndex(_ index: Int) -> TictacToeGradients {
        allCases[index % allCases.count]
    }
}

final class TicTacToeCollectionViewCell: UICollectionViewCell {

    // MARK: - UI
    private let gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .wcVelvet
        view.applyCornerRadious(12, borderWidth: 3, borderColor: .white)
        view.applyShadow()
        return view
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
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Setup
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.applyCornerRadious(16)
        applyShadow()

        contentView.addSubviews([gradientView, imageContainerView, titleLabel])
        imageContainerView.addSubview(imageView)

        NSLayoutConstraint.activate([
            // make the content square
            contentView.heightAnchor.constraint(equalTo: contentView.widthAnchor),

            // gradientView: top 35%
            gradientView.topAnchor.constraint(equalTo: contentView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gradientView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.4),

            // imageContainerView: HALF of main container
            imageContainerView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageContainerView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            imageContainerView.heightAnchor.constraint(equalTo: imageContainerView.widthAnchor),

            // half on gradient, half outside
            imageContainerView.centerYAnchor.constraint(equalTo: gradientView.bottomAnchor),

            // title under container
            titleLabel.topAnchor.constraint(equalTo: imageContainerView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),

            // imageView: HALF of image container
            imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: imageContainerView.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
        ])
    }

    // MARK: - Public API
    var gradientHostView: UIView { gradientView }

    func configure(title: String, imgURL: String?, gradient: TictacToeGradients) {
        titleLabel.text = title
        gradientView.applyGradient(colors: gradient.colors, direction: .horizontal)

        if let imgURL, imgURL.isNotEmpty {
            imageView.setImage(from: imgURL)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        titleLabel.text = nil
    }
}
