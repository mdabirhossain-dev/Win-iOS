//
//
//  HomeQuizCategoryTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 17/1/26.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class HomeQuizCategoryTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
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
        header.setTitle("কুইজ ক্যাটেগরি")
        return header
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = CollectionLayoutFactory.makeLayout([
            .carousel(
                visibleCount: 2.5,
                aspectRatio: 1.0, // square
                contentInsets: .init(top: 0, leading: 16, bottom: 0, trailing: 16),
                itemSpacing: 8,
                scrolling: .continuous
            )
        ])

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.allowsMultipleSelection = false
        collectionView.register(
            QuizCategoryCollectionViewCell.self,
            forCellWithReuseIdentifier: QuizCategoryCollectionViewCell.className
        )
        return collectionView
    }()

    private let visibleCount: CGFloat = 2.5
    private let itemSpacing: CGFloat = 8
    private let sideInset: CGFloat = 16

    private var collectionHeightConstraint: NSLayoutConstraint?

    private var quizCategories: [QuizCategory] = []

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubviews([headerView, collectionView])

        // ✅ real height for collection
        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 1)
        collectionHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCollectionHeightIfNeeded()
    }

    private func updateCollectionHeightIfNeeded() {
        let containerW = contentView.bounds.width
        guard containerW > 0 else { return }

        let availableW = containerW - (sideInset * 2)
        let gaps = max(visibleCount - 1, 0)
        let itemW = (availableW - gaps * itemSpacing) / max(visibleCount, 1)
        let itemH = itemW // square

        if abs((collectionHeightConstraint?.constant ?? 0) - itemH) > 0.5 {
            collectionHeightConstraint?.constant = itemH
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        quizCategories.removeAll()
        collectionView.setContentOffset(.zero, animated: false)
        collectionView.reloadData()
    }

    func configure(_ quizCategories: [QuizCategory]) {
        self.quizCategories = quizCategories
        collectionView.reloadData()
        updateCollectionHeightIfNeeded()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        quizCategories.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: QuizCategoryCollectionViewCell.className,
            for: indexPath
        ) as! QuizCategoryCollectionViewCell

        let quiz = quizCategories[indexPath.item]
        cell.configure(title: quiz.title ?? "", centerImg: quiz.imageSource)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let _ = quizCategories[indexPath.item]
    }
}


// MARK: - CollectionView Cell
final class QuizCategoryCollectionViewCell: UICollectionViewCell {

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()

    private let centerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .winFont(.semiBold, size: .medium)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
        centerImageView.image = nil
        titleLabel.text = nil
    }

    private func setupView() {
        contentView.backgroundColor = .white
        contentView.applyCornerRadious(16)
//        contentView.applyShadow()

        contentView.addSubview(stackView)
        stackView.addArrangedSubview(centerImageView)
        stackView.addArrangedSubview(titleLabel)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            centerImageView.heightAnchor.constraint(equalTo: centerImageView.widthAnchor),
            centerImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            centerImageView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor, multiplier: 0.6)
        ])
    }

    func configure(title: String, centerImg: String?) {
        titleLabel.text = title

        if let centerImg, centerImg.isNotEmpty {
            centerImageView.setImage(from: centerImg)
        } else {
            centerImageView.image = nil
        }
    }
}
