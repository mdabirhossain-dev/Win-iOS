//
//
//  AvaterCollectionViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

class AvaterCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private let checkContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .wcVelvet
        v.applyCornerRadious(11)
        v.isHidden = true
        return v
    }()

    private let checkImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "checkmark"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubviews([imageView, checkContainer])
        checkContainer.addSubview(checkImageView)

        contentView.applyCornerRadious(12)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            checkContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            checkContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            checkContainer.heightAnchor.constraint(equalToConstant: 22),
            checkContainer.widthAnchor.constraint(equalToConstant: 22),

            checkImageView.centerXAnchor.constraint(equalTo: checkContainer.centerXAnchor),
            checkImageView.centerYAnchor.constraint(equalTo: checkContainer.centerYAnchor),
            checkImageView.heightAnchor.constraint(equalToConstant: 16),
            checkImageView.widthAnchor.constraint(equalToConstant: 16)
        ])
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        checkContainer.isHidden = true
    }

    func configure(avatar: UserAvatar, isSelected: Bool, imageURLString: String?) {
        checkContainer.isHidden = !isSelected
        guard let url = imageURLString else {
            imageView.image = UIImage(resource: .winProfileCircle)
            return
        }
        imageView.setImage(from: url, placeholder: UIImage(resource: .winProfileCircle))
    }
}
