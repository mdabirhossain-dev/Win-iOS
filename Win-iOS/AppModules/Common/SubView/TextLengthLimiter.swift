//
//
//  TextLengthLimiter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 17/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//



import UIKit

final class InputLimiter: NSObject, UITextViewDelegate, UITextFieldDelegate {
    
    private let maxLength: Int
    
    init(maxLength: Int) {
        self.maxLength = maxLength
    }
    
    // MARK: - UITextViewDelegate
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        return shouldAllowChange(currentText: textView.text ?? "",
                                 range: range,
                                 replacement: text)
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return shouldAllowChange(currentText: textField.text ?? "",
                                 range: range,
                                 replacement: string)
    }
    
    // MARK: - Core logic
    private func shouldAllowChange(currentText: String,
                                   range: NSRange,
                                   replacement: String) -> Bool {
        guard let textRange = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: textRange, with: replacement)
        return updatedText.count <= maxLength
    }
}
