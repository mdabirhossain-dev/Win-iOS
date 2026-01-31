//
//
//  InvitationHistoryTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 30/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class InvitationHistoryTableViewCell: UITableViewCell {

    // MARK: - UI Properties
    private let rootStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()

    private let inviteImageView: UIImageView = {
        let base = UIImage(resource: .inviteUser).withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: base.withPadding(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)))

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .center
        imageView.tintColor = .wcVelvet
        imageView.backgroundColor = .wcPinkLight
        imageView.applyCornerRadious(16)

        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()

    private let joinDateAndMSISDNStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 4
        stack.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return stack
    }()

    private let joinDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .winFont(.regular, size: .small)
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private let msisdnLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .winFont(.bold, size: .small)
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private let starImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .starYellow3D))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .wcPinkLight
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        return imageView
    }()

    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .winFont(.bold, size: .small)
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    private func setupView() {
        backgroundColor = .white
        applyCornerRadious(8)
        applyShadow()

        contentView.addSubview(rootStackView)

        rootStackView.addArrangedSubviews([
            inviteImageView,
            joinDateAndMSISDNStackView,
            starImageView,
            pointsLabel
        ])

        joinDateAndMSISDNStackView.addArrangedSubviews([
            joinDateLabel,
            msisdnLabel
        ])

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            inviteImageView.widthAnchor.constraint(equalToConstant: 32),
            inviteImageView.heightAnchor.constraint(equalToConstant: 32),

            starImageView.widthAnchor.constraint(equalToConstant: 16),
            starImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }

    // MARK: - Configure
    func configure(with invitation: InvitationResponse?) {
        guard
            let invitation,
            let onDate = invitation.joinDateBengali,
            let msisdn = invitation.msisdn,
            let points = invitation.point
        else {
            // clear (avoid reused garbage)
            joinDateLabel.text = nil
            msisdnLabel.text = nil
            pointsLabel.text = nil
            return
        }

        joinDateLabel.text = onDate
        msisdnLabel.text = msisdn.dropLeading88().toBanglaNumberWithSuffix()
        pointsLabel.text = "+\(points)".toBanglaNumberWithSuffix()
    }
}

//class InvitationHistoryTableViewCell: UITableViewCell {
//    
//    // MARK: - UI Properties
//    private let rootStackView: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.spacing = 12
//        stack.alignment = .center
//        stack.distribution = .fill
//        return stack
//    }()
//    
////    private let inviteImageView: UIImageView = {
////        let imageView = UIImageView(image: UIImage(resource: .inviteUser))
////        imageView.translatesAutoresizingMaskIntoConstraints = false
////        imageView.contentMode = .scaleAspectFit
////        imageView.tintColor = .wcVelvet
////        imageView.backgroundColor = .wcPinkLight
////        imageView.layoutMargins = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
////        imageView.applyCornerRadious(16)
////        imageView.setContentHuggingPriority(.required, for: .horizontal)
////        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
////        return imageView
////    }()
//    private let inviteImageView: UIImageView = {
//        let base = UIImage(resource: .inviteUser).withRenderingMode(.alwaysTemplate)
//        let imageView = UIImageView(image: base.withPadding(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)))
//
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.contentMode = .center
//        imageView.tintColor = .wcVelvet
//        imageView.backgroundColor = .wcPinkLight
//        imageView.applyCornerRadious(16)
//
//        imageView.setContentHuggingPriority(.required, for: .horizontal)
//        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
//        return imageView
//    }()
//    private let joinDateAndMSISDNStackView: UIStackView = {
//        let stack = UIStackView()
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .vertical
//        stack.alignment = .leading
//        stack.spacing = 4
//        stack.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        return stack
//    }()
//    private let joinDateLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .winFont(.regular, size: .small)
//        label.numberOfLines = 1
//        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//        return label
//    }()
//    private let msisdnLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = .black
//        label.font = .winFont(.bold, size: .small)
//        label.numberOfLines = 1
//        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//        return label
//    }()
//    
//    private let starImageView: UIImageView = {
//        let imageView = UIImageView(image: UIImage(resource: .starYellow3D))
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.tintColor = .wcPinkLight
//        imageView.contentMode = .scaleAspectFit
//        imageView.setContentHuggingPriority(.required, for: .horizontal)
//        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
//        return imageView
//    }()
//    
//    private let pointsLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.font = .winFont(.bold, size: .small)
//        label.numberOfLines = 1
//        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//        return label
//    }()
//
//    // MARK: - Init
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupView()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Setup
//    private func setupView() {
//        backgroundColor = .white
//        applyCornerRadious(8)
//        applyShadow()
//        
//        contentView.addSubview(rootStackView)
//        
//        rootStackView.addArrangedSubviews([
//            inviteImageView,
//            joinDateAndMSISDNStackView,
//            starImageView,
//            pointsLabel
//        ])
//        joinDateAndMSISDNStackView.addArrangedSubviews([
//            joinDateLabel,
//            msisdnLabel,
//        ])
//        
//        NSLayoutConstraint.activate([
//            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
//            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
//            
//            inviteImageView.widthAnchor.constraint(equalToConstant: 32),
//            inviteImageView.heightAnchor.constraint(equalToConstant: 32),
//            
//            starImageView.widthAnchor.constraint(equalToConstant: 16),
//            starImageView.heightAnchor.constraint(equalToConstant: 16),
//        ])
//    }
//    
//    // MARK: - Configure
//    func configure(with invitation: InvitationResponse?) {
//        guard
//            let invitation,
//            let onDate = invitation.joinDateBengali,
//            let msisdn = invitation.msisdn,
//            let points = invitation.point
//        else { return }
//        
//        joinDateLabel.text = onDate
//        msisdnLabel.text = msisdn.dropLeading88().toBanglaNumberWithSuffix()
//        pointsLabel.text = "+\(points)".toBanglaNumberWithSuffix()
//    }
//}
