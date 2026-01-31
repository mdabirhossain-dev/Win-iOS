//
//
//  ProfileUserInfoCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 7/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class ProfileUserInfoCell: UICollectionViewCell {
    // MARK: - UI
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.applyCornerRadious(36)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .wcVelvetDark
        label.font = .winFont(.bold, size: .large)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .winFont(.regular, size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .wcPinkLight
        applyCornerRadious(16)
        
        addSubview(stackView)
        stackView.addArrangedSubviews([profileImageView, phoneNumberLabel, userNameLabel])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            
            profileImageView.widthAnchor.constraint(equalToConstant: 72),
            profileImageView.heightAnchor.constraint(equalToConstant: 72),
            
            phoneNumberLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor)
        ])
    }
    
    // MARK: - Configure
    func configure(name: String?, avatarURLString: String?, number: String? = nil) {
        if let number { phoneNumberLabel.text = number.dropLeading88().toBanglaNumberWithSuffix() }
        if let name { userNameLabel.text = name }
        if let url = avatarURLString {
            profileImageView.setImage(from: url, placeholder: UIImage(resource: .winProfileCircle))
        }
    }
}
