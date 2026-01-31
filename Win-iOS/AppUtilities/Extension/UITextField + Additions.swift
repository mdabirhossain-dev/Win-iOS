//
//
//  UITextField + Additions.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 23/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

public extension UITextField {
    func dismissKeyboardOnReturn() {
        returnKeyType = .done
        addTarget(self, action: #selector(resignFirstResponder), for: .editingDidEndOnExit)
    }
}

public extension UITextField {
    func addDoneAccessory() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))
        ]
        inputAccessoryView = toolbar
    }
}

public extension UITextView {
    func addDoneAccessory() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))
        ]
        inputAccessoryView = toolbar
    }
}


//phoneField.keyboardType = .phonePad
//phoneField.addDoneAccessory()
//
//nameField.dismissKeyboardOnReturn()
//
//scrollView.keyboardDismissMode = .interactive // or .onDrag

