//
//
//  UIButton + Additions.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 30/9/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

extension UIButton {
    func pulse() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.15
        pulse.fromValue = 0.95
        pulse.toValue = 1.0
        layer.add(pulse, forKey: "pulse")
    }
    
    func font(_ font: UIFont, title: String? = nil, color: UIColor = .black) {
        let finalTitle = title ?? self.title(for: .normal) ?? ""
        let attributed = NSAttributedString(
            string: finalTitle,
            attributes: [
                .font: font,
                .foregroundColor: color
            ]
        )
        self.setAttributedTitle(attributed, for: .normal)
    }
}

class VerticalButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentHorizontalAlignment = .right
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        centerButtonImageAndTitle()
    }
    
    private func centerButtonImageAndTitle() {
        let titleSize = self.titleLabel?.frame.size ?? .zero
        let imageSize = self.imageView?.frame.size  ?? .zero
        let spacing: CGFloat = 4.0
        self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing),left: 0, bottom: 0, right:  -titleSize.width)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -(imageSize.height + spacing), right: 0)
    }
}
