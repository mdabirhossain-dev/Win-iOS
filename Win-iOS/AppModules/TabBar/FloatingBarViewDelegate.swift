//
//
//  FloatingBarViewDelegate.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 30/9/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

protocol FloatingBarViewDelegate: AnyObject {
    func did(selectindex: Int)
}

class FloatingBarView: UIView {
    weak var delegate: FloatingBarViewDelegate?
    
    var buttons: [UIButton] = []
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "হোম"
        label.font = .winFont(.regular, size: .extraSmall)
        label.textAlignment = .center
        return label
    }()
    
    init(_ items: [TabbarItems]) {
        super.init(frame: .zero)
        setupStackView(items)
        updateUI(selectedIndex: 0)
        setupCustomView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addShape()
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: -3) // negative height to create a top shadow
        layer.shadowRadius = 2.0
    }
    
    private func setupCustomView() {
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    func setupStackView(_ items: [TabbarItems]) {
        for (index, item) in items.enumerated() {
            let itemImage = item.image ?? UIImage()
            let button = createButton(title: item.title,
                                      normalImage: itemImage,
                                      selectedImage: itemImage,
                                      index: index)
            buttons.append(button)
        }
        
        let stackView = UIStackView(arrangedSubviews: buttons)
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.fillSuperview(padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    func createButton(title: String, normalImage: UIImage, selectedImage: UIImage, index: Int) -> UIButton {
        let button = VerticalButton()
        button.setImage(normalImage, for: .normal)
        
        button.setImage(
            selectedImage
                .withRenderingMode(.alwaysTemplate)
                .withTintColor(.wcPink.withAlphaComponent(0.9)),
            for: .selected
        )
        
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .winFont(.regular, size: .extraSmall)
        button.setTitleColor(.gray, for: .normal)
        
        button.contentVerticalAlignment = .center
        button.tag = index
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(changeTab(_:)), for: .touchUpInside)
        return button
    }
    
    @objc func changeTab(_ sender: UIButton) {
        sender.pulse()
        delegate?.did(selectindex: sender.tag)
        updateUI(selectedIndex: sender.tag)
    }
    
    func updateUI(selectedIndex: Int) {
        for (index, button) in buttons.enumerated() {
            if index == selectedIndex {
                button.isSelected = true
                button.tintColor = .wcPink
                button.setTitleColor(.wcPink, for: .normal)
            } else {
                button.isSelected = false
                button.tintColor = .gray
                button.setTitleColor(.gray, for: .normal)
            }
        }
        
        titleLabel.textColor = (selectedIndex == 1) ? .wcPink : .gray
    }
    
    func toggle(hide: Bool) {
        if !hide {
            isHidden = hide
        }
        
        UIView.animate(withDuration: 0.25,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0.5,
                       options: .curveEaseOut,
                       animations: {
            self.alpha = hide ? 0 : 1
            self.transform = hide ? CGAffineTransform(translationX: 0, y: 10) : .identity
        }) { _ in
            if hide {
                self.isHidden = hide
            }
        }
    }
    
    private var shapeLayer: CAShapeLayer?
    
    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1.0
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {
        let cutRadius: CGFloat = 26.0
        let path = UIBezierPath()
        let centerX = self.frame.width / 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: centerX, y: 0))
        
        // half circle downward
        path.addArc(
            withCenter: CGPoint(x: centerX, y: 0),
            radius: cutRadius,
            startAngle: .pi,
            endAngle: 0,
            clockwise: false
        )
        
        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()
        
        return path.cgPath
    }
}
