//
//
//  WinTextView.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 17/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//



import UIKit

class WinTextView: UITextView {
    
    // MARK: - Padding
    private let inset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    
    // MARK: - Customizable border properties
    var borderColor: UIColor = .lightGray {
        didSet {
            layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        }
    }
    
    var borderWidth: CGFloat = 1.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    var cornerRadius: CGFloat = 10.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    // MARK: - Placeholder
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.font = .winFont(.regular, size: .small)
        label.numberOfLines = 0
        return label
    }()
    
    var placeholder: String = "" {
        didSet {
            placeholderLabel.text = placeholder
        }
    }
    
    override var text: String! {
        didSet {
            updatePlaceholderVisibility()
        }
    }
    
    override var attributedText: NSAttributedString! {
        didSet {
            updatePlaceholderVisibility()
        }
    }
    
    override var font: UIFont? {
        didSet {
            placeholderLabel.font = .winFont(.regular, size: .small)
        }
    }
    
    // MARK: - Init
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        // Border + corner radius (initial)
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        // Text padding
        textContainerInset = inset
        
        self.tintColor = .wcVelvet
        self.textColor = .black
        
        addDoneAccessory()
        
        // Placeholder
        addSubview(placeholderLabel)
        placeholderLabel.isHidden = !text.isEmpty
        
        // Auto Layout for placeholder (more robust than manual frame)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset.top),
            placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset.left + 4),
            placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(inset.right + 4))
        ])
        
        // Observe text changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChangeNotification(_:)),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }
    
    @objc private func textDidChangeNotification(_ notification: Notification) {
        updatePlaceholderVisibility()
    }
    
    private func updatePlaceholderVisibility() {
        placeholderLabel.isHidden = !text.isEmpty
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

