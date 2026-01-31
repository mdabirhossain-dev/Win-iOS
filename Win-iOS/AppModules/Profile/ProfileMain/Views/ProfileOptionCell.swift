//
//
//  ProfileOptionCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 9/10/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - Reusable row UI (used by BOTH cell + button)
final class ProfileOptionRowView: UIView {

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .winFont(.regular, size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let spacer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let rightImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        backgroundColor = .white
        applyCornerRadious(8)
        applyShadow()

        addSubview(stackView)
        stackView.addArrangedSubviews([leftImageView, titleLabel, spacer, rightImageView])

        // Push chevron to the right
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),

            leftImageView.widthAnchor.constraint(equalToConstant: 24),
            leftImageView.heightAnchor.constraint(equalToConstant: 24),

            rightImageView.widthAnchor.constraint(equalToConstant: 24),
            rightImageView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }

    func configure(title: String, imageName: String) {
        titleLabel.text = title
        leftImageView.image = UIImage(named: imageName)
    }
}

// MARK: - UICollectionViewCell (still usable inside collectionView)
final class ProfileOptionCell: UICollectionViewCell {

    private let rowView = ProfileOptionRowView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.backgroundColor = .clear
        contentView.addSubview(rowView)
        rowView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            rowView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rowView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rowView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rowView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    func configure(title: String, image: String) {
        rowView.configure(title: title, imageName: image)
    }
}
