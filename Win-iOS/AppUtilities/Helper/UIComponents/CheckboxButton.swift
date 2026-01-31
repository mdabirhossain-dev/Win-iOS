//
//
//  CheckboxButton.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 29/9/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//

import UIKit

class CheckboxButton: UIButton {
    
    // Default SF Symbols for checked and unchecked states
    private let checkedImage = UIImage(systemName: "checkmark.square.fill")
    private let uncheckedImage = UIImage(systemName: "square")
    
    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        
        // Set the default images for normal and selected states
        self.setImage(checkedImage, for: .selected)
        self.setImage(uncheckedImage, for: .normal)
        
        // Set a default size for the checkbox button
        self.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        
        self.tintColor = .black
        
        // Add target for toggle action
        self.addTarget(self, action: #selector(toggleCheckbox), for: .touchUpInside)
    }
    
    // Toggle the checkbox between checked and unchecked states
    @objc private func toggleCheckbox() {
        self.isSelected.toggle()
        
        if self.isSelected {
            self.tintColor = .wcGreen
        } else {
            self.tintColor = .black
        }
        
        // You can use the state (selected or not) to trigger additional actions if needed
        Log.info("Checkbox is \(isSelected ? "selected" : "unselected")!")
    }
}
