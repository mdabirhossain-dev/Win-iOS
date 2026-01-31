//
//
//  TotalPointAndScoreTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class TotalPointAndScoreTableViewCell: UITableViewCell {
    
    // MARK: - UI Properties
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let pointImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let totalPointNumberLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .wcVelvetDark
        label.font = .winFont(.bold, size: .extraLarge)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalPointLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .winFont(.regular, size: .large)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        contentView.applyCornerRadious(16)
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews([
            pointImageView,
            totalPointNumberLabel,
            totalPointLabel
        ])
        
        let margins = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 4),
            stackView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -4),
            
            pointImageView.heightAnchor.constraint(equalToConstant: 32),
            pointImageView.widthAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    // MARK: - Configure
    func configure(type: PointsType) {
        switch type {
        case .totalPoint:
            contentView.backgroundColor = .wcPinkLight
        case .totalScore:
            contentView.backgroundColor = .wcYellowLight
        }
        
        pointImageView.image = type.image
        totalPointNumberLabel.text = "\(type.score)".toBanglaNumberWithSuffix()
        totalPointLabel.text = type.typeLabel.replacingOccurrences(of: "মোট", with: "সর্বমোট")
    }
}
