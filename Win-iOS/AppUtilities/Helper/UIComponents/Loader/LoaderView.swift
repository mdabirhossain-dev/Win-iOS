//
//
//  LoaderView.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//

import UIKit

final class LoaderView: UIView {
    
    // Called when user taps retry button (for empty / error)
    var retryHandler: (() -> Void)?
    
    private let activity = UIActivityIndicatorView(style: .large)
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    private let button = UIButton(type: .system)
    private let stack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = .wcBackground.withAlphaComponent(0.7)
        
        activity.color = .wcVelvet
        activity.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activity.hidesWhenStopped = true
        
        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        messageLabel.font = .systemFont(ofSize: 15)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        
        stack.addArrangedSubviews([activity, titleLabel, messageLabel, button])
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),
            stack.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, constant: -32)
        ])
    }
    
    @objc private func didTapRetry() {
        retryHandler?()
    }
    
    // MARK: - Public
    func setState(_ state: LoaderState) {
        switch state {
        case .hidden:
            isHidden = true
            activity.stopAnimating()
            titleLabel.isHidden = true
            messageLabel.isHidden = true
            button.isHidden = true
            
        case .loading:
            isHidden = false
            activity.startAnimating()
            titleLabel.isHidden = true
            messageLabel.isHidden = true
            button.isHidden = true
            
        case .empty(let message):
            isHidden = false
            activity.stopAnimating()
            titleLabel.isHidden = false
            messageLabel.isHidden = false
            button.isHidden = false
            
            titleLabel.text = "No Data"
            messageLabel.text = message
            button.setTitle("Reload", for: .normal)
            
        case .error(let message):
            isHidden = false
            activity.stopAnimating()
            titleLabel.isHidden = false
            messageLabel.isHidden = false
            button.isHidden = false
            
            titleLabel.text = "Error"
            messageLabel.text = message
            button.setTitle("Try Again", for: .normal)
        }
    }
}
