//
//
//  WinTextField.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/9/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

//final class WinTextField: UITextField {
//
//    // MARK: - Public API
//
//    var autoFillWidth: Bool = true { didSet { reapplyAutoFillWidthConstraints() } }
//    var autoFillInsets: UIEdgeInsets = .zero { didSet { reapplyAutoFillWidthConstraints() } }
//
//    var leftImage: UIImage? { didSet { updateLeftView() } }
//    var rightImage: UIImage? { didSet { updateRightView() } }
//
//    var rightImageColor: UIColor? { didSet { rightImageViewRef?.tintColor = rightImageColor } }
//
//    var borderColor: UIColor = .lightGray { didSet { applyDefaultBorder() } }
//
//    var isValid: Bool = true { didSet { applyValidationBorder() } }
//
//    // MARK: - Private
//
//    private let fixedHeight: CGFloat = 48
//    private let iconSize: CGFloat = 20
//
//    /// This is the REAL spacing you asked for.
//    private let padding: CGFloat = 8
//
//    private weak var rightImageViewRef: UIImageView?
//    private var autoWidthConstraints: [NSLayoutConstraint] = []
//
//    // MARK: - Init
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//
//    // MARK: - Setup
//
//    private func setup() {
//        translatesAutoresizingMaskIntoConstraints = false
//        heightAnchor.constraint(equalToConstant: fixedHeight).isActive = true
//
//        layer.cornerRadius = fixedHeight / 2
//        layer.borderWidth = 1
//        layer.masksToBounds = true
//
//        font = .winFont(.regular, size: .small)
//        tintColor = .wcVelvet
//        textColor = .black
//
//        leftViewMode = .always
//        rightViewMode = .always
//
//        addDoneAccessory()
//
//        applyDefaultBorder()
//        updateLeftView()
//        updateRightView()
//
//        addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
//        addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
//    }
//
//    // MARK: - Auto fill width (optional convenience)
//
//    override func didMoveToSuperview() {
//        super.didMoveToSuperview()
//        reapplyAutoFillWidthConstraints()
//    }
//
//    private func reapplyAutoFillWidthConstraints() {
//        NSLayoutConstraint.deactivate(autoWidthConstraints)
//        autoWidthConstraints.removeAll()
//
//        guard autoFillWidth, let superview, !(superview is UIStackView) else { return }
//
//        let leading = leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: autoFillInsets.left)
//        let trailing = trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -autoFillInsets.right)
//
//        NSLayoutConstraint.activate([leading, trailing])
//        autoWidthConstraints = [leading, trailing]
//    }
//
//    // MARK: - Text alignment / padding (FIXED)
//
//    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        paddedRect(super.textRect(forBounds: bounds))
//    }
//
//    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        paddedRect(super.editingRect(forBounds: bounds))
//    }
//
//    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        paddedRect(super.placeholderRect(forBounds: bounds))
//    }
//
//    private func paddedRect(_ rect: CGRect) -> CGRect {
//        // IMPORTANT:
//        // When leftView/rightView exists, UIKit already shifts text start/end.
//        // So we add 8pt ONLY when that view is missing to avoid double space.
//        let leftInset: CGFloat = (leftView == nil) ? padding : 0
//        let rightInset: CGFloat = (rightView == nil) ? padding : 0
//
//        return rect.inset(by: UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset))
//    }
//
//    // MARK: - Left / Right Views (FIXED spacing)
//
//    private func updateLeftView() {
//        guard let img = leftImage else {
//            leftView = nil
//            return
//        }
//
//        // Container width = left padding + icon + right padding
//        let w = padding + iconSize + padding
//        let container = UIView(frame: CGRect(x: 0, y: 0, width: w, height: fixedHeight))
//        container.backgroundColor = .clear
//
//        let iv = UIImageView(image: img)
//        iv.contentMode = .scaleAspectFit
//        iv.tintColor = .black
//        iv.frame = CGRect(x: padding, y: (fixedHeight - iconSize) / 2, width: iconSize, height: iconSize)
//
//        container.addSubview(iv)
//        leftView = container
//    }
//
//    private func updateRightView() {
//        guard let img = rightImage else {
//            rightView = nil
//            rightImageViewRef = nil
//            return
//        }
//
//        let w = padding + iconSize + padding
//        let container = UIView(frame: CGRect(x: 0, y: 0, width: w, height: fixedHeight))
//        container.backgroundColor = .clear
//
//        let iv = UIImageView(image: img.withRenderingMode(.alwaysTemplate))
//        iv.contentMode = .scaleAspectFit
//        iv.tintColor = rightImageColor
//        iv.frame = CGRect(x: padding, y: (fixedHeight - iconSize) / 2, width: iconSize, height: iconSize)
//
//        container.addSubview(iv)
//        rightImageViewRef = iv
//        rightView = container
//    }
//
//    // MARK: - Border
//
//    private func applyDefaultBorder() {
//        layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
//    }
//
//    private func applyValidationBorder() {
//        layer.borderColor = isValid ? UIColor.green.cgColor : UIColor.red.cgColor
//    }
//
//    @objc private func didBeginEditing() {
//        layer.borderColor = UIColor.wcGreen.withAlphaComponent(0.3).cgColor
//    }
//
//    @objc private func didEndEditing() {
//        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
//        // If you want validity-based after editing:
//        // applyValidationBorder()
//    }
//}


//tf.autoFillInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)?


class WinTextField: UITextField {
    
    var leftImage: UIImage? {
        didSet {
            setLeftImage()
        }
    }
    
    var rightImage: UIImage? {
        didSet {
            setRightImage()
        }
    }
    
    var rightImageColor: UIColor? {
        didSet {
            setRightImage()
        }
    }
    
    var borderColor: UIColor = .lightGray {
        didSet {
            self.layer.borderColor = borderColor.withAlphaComponent(0.3).cgColor
        }
    }
    
    var isValid: Bool = true {
        didSet {
            self.layer.borderColor = isValid ? UIColor.green.cgColor : UIColor.red.cgColor
        }
    }
    
    // MARK: - Eye Button (Optional for Later)
    private var eyeButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    private func setup() {
        self.heightAnchor.constraint(equalToConstant: 48).isActive = true
        self.layer.cornerRadius = 25
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        
        self.placeholder = "Enter text"
        self.font = .winFont(.regular, size: .small)
        self.tintColor = .wcVelvet
        self.textColor = .black
        
        // Add left and right image views
        self.leftViewMode = .always
        self.rightViewMode = .always
        
        self.addDoneAccessory()
        
        // Set default images
        setLeftImage()
        setRightImage()
        
        // Add focus event handlers for border color
        self.addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
    }
    
    // MARK: - Image Setup
    private func setLeftImage() {
        if let image = leftImage {
            let leftImageView = UIImageView(image: image)
            leftImageView.contentMode = .scaleAspectFit
            leftImageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
            leftImageView.tintColor = .black
            
            let containerView = UIView()
            containerView.frame = CGRect(x: 0, y: 0, width: 40, height: self.bounds.height)  // Match text field height
            containerView.addSubview(leftImageView)
            
            // Center the image vertically and horizontally within the container view
            leftImageView.center = CGPoint(x: containerView.bounds.midX, y: containerView.bounds.midY)
            
            self.leftView = containerView
        }
    }
    
    private func setRightImage() {
        if let image = rightImage {
            let rightImageView = UIImageView(image: image)
            rightImageView.contentMode = .scaleAspectFit
            rightImageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20)
            rightImageView.tintColor = rightImageColor
            
            let containerView = UIView()
            containerView.frame = CGRect(x: 0, y: 0, width: 40, height: self.bounds.height)  // Match text field height
            containerView.addSubview(rightImageView)
            
            // Center the image vertically and horizontally within the container view
            rightImageView.center = CGPoint(x: containerView.bounds.midX, y: containerView.bounds.midY)
            
            self.rightView = containerView
        }
    }
    
    // MARK: - Focus Border Color Change
    @objc private func didBeginEditing() {
        self.layer.borderColor = UIColor.wcGreen.withAlphaComponent(0.3).cgColor
    }
    
    @objc private func didEndEditing() {
//        self.layer.borderColor = isValid ? UIColor.green.cgColor : UIColor.red.cgColor
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.3).cgColor
    }
    
    // MARK: - Layout Constraints (Dynamic Width)
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        if let superview = self.superview {
            NSLayoutConstraint.activate([
                self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                self.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
            ])
        }
    }
}


