//
//
//  WinButtonWithImage.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 28/9/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//

import UIKit

class WinButtonWithImage: UIButton {
    
    // Default values
    private let defaultHeight: CGFloat = 48
    private let defaultCornerRadiusFactor: CGFloat = 0.5  // Corner radius will be half the height
    private let imageSpacing: CGFloat = 10  // Space between the image and text

    // Initializer for programmatically creating the button
    init(frame: CGRect = .zero, height: CGFloat? = nil, cornerRadius: CGFloat? = nil, textColor: UIColor? = nil, backgroundColor: UIColor? = .white, image: UIImage? = nil, title: String? = nil) {
        super.init(frame: frame)
        
        // Set default height and adjust button's frame
        let buttonHeight = height ?? defaultHeight
        self.frame.size.height = buttonHeight
        self.layer.cornerRadius = cornerRadius ?? (buttonHeight * defaultCornerRadiusFactor)
        
        // Set default button properties (background color, text color)
        self.setTitleColor(textColor ?? .white, for: .normal)
        self.backgroundColor = backgroundColor ?? .blue
        
        // Set button title and image
        if let image = image {
            self.setImage(image, for: .normal)
        }
        
        if let title = title {
            self.setTitle(title, for: .normal)
        }
        
        // Adjust title and image alignment
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: imageSpacing, bottom: 0, right: imageSpacing)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: imageSpacing * 2, bottom: 0, right: 0)
        
        // Set the content mode and alignment to align image and text to the left
        self.contentHorizontalAlignment = .left
        self.titleLabel?.textAlignment = .left
        self.titleLabel?.font = .winFont(.regular, size: .small)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Automatically fill the width if not explicitly set
        fillSuperviewWidthIfNeeded()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // This method ensures that the button fills the width of its superview if no explicit width is provided
    private func fillSuperviewWidthIfNeeded() {
        if self.frame.width == 0 {
            // If width is not provided, fill the superview's width
            guard let superview = self.superview else { return }
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
        } else {
            // If width is explicitly set, no need to adjust
            self.widthAnchor.constraint(equalToConstant: self.frame.width).isActive = true
        }
    }

    // Method to change the background color dynamically
    func setDynamicBackgroundColor(_ color: UIColor) {
        self.backgroundColor = color
    }
}
