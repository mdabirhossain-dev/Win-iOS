//
//
//  ProfileSocialInfoCellViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/10/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class ProfileSocialInfoCollectionViewCell: UICollectionViewCell {
    // MARK: - UI
    private let rootStackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 8
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let animationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .winFont(.bold, size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let rightImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .left
        label.font = .winFont(.regular, size: .extraSmall)
        label.numberOfLines = 0
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
        contentView.applyCornerRadious(8)
        contentView.applyShadow()
        
        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubviews([animationView, contentStackView, rightImageView])
        contentStackView.addArrangedSubviews([titleLabel, descriptionLabel])
        
        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            animationView.widthAnchor.constraint(equalToConstant: 40),
            animationView.heightAnchor.constraint(equalToConstant: 40),
            
            rightImageView.widthAnchor.constraint(equalToConstant: 24),
            rightImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    // MARK: - Configure
    func configure(_ social: SocialInfoModel) {
        animationView.subviews.forEach { $0.removeFromSuperview() }
        
        let lottieView = LottieAnimationViewContainer(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        lottieView.setAnimation(named: social.animation, loopMode: .loop)
        animationView.addSubview(lottieView)
        
        contentView.backgroundColor = (social.animation == .telegram) ? .wcBlueLight : .white
        titleLabel.text = social.title
        descriptionLabel.text = social.description
    }
}
