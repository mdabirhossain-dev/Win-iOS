//
//
//  UILabel + Additions.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 1/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit
import ObjectiveC

private var textInsetsKey: UInt8 = 0

extension UILabel {
    
    /// Padding around the label's text.
    var padding: UIEdgeInsets {
        get {
            (objc_getAssociatedObject(self, &textInsetsKey) as? NSValue)?
                .uiEdgeInsetsValue ?? .zero
        }
        set {
            // Ensure swizzling happens once
            UILabel._padding_swizzleIfNeeded()
            
            let value = NSValue(uiEdgeInsets: newValue)
            objc_setAssociatedObject(self, &textInsetsKey, value, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            invalidateIntrinsicContentSize()
            setNeedsDisplay()
        }
    }
    
    // MARK: - Swizzling
    
    private static var _didSwizzlePadding = false
    
    fileprivate static func _padding_swizzleIfNeeded() {
        guard !_didSwizzlePadding else { return }
        _didSwizzlePadding = true
        
        // drawText(in:)
        let originalDrawSel = #selector(UILabel.drawText(in:))
        let swizzledDrawSel = #selector(UILabel._padding_drawText(in:))
        
        if let originalMethod = class_getInstanceMethod(UILabel.self, originalDrawSel),
           let swizzledMethod = class_getInstanceMethod(UILabel.self, swizzledDrawSel) {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        
        // intrinsicContentSize
        let originalIntrinsicSel = #selector(getter: UILabel.intrinsicContentSize)
        let swizzledIntrinsicSel = #selector(UILabel._padding_intrinsicContentSize)
        
        if let originalMethod = class_getInstanceMethod(UILabel.self, originalIntrinsicSel),
           let swizzledMethod = class_getInstanceMethod(UILabel.self, swizzledIntrinsicSel) {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
        
        // sizeThatFits(_:)
        let originalSizeSel = #selector(UILabel.sizeThatFits(_:))
        let swizzledSizeSel = #selector(UILabel._padding_sizeThatFits(_:))
        
        if let originalMethod = class_getInstanceMethod(UILabel.self, originalSizeSel),
           let swizzledMethod = class_getInstanceMethod(UILabel.self, swizzledSizeSel) {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    // MARK: - Swizzled implementations
    @objc private func _padding_drawText(in rect: CGRect) {
        let insets = padding
        if insets == .zero {
            _padding_drawText(in: rect) // calls original drawText(in:)
        } else {
            let insetRect = rect.inset(by: insets)
            _padding_drawText(in: insetRect)
        }
    }
    
    @objc private func _padding_intrinsicContentSize() -> CGSize {
        let baseSize = _padding_intrinsicContentSize() // original intrinsicContentSize
        let insets = padding
        if insets == .zero {
            return baseSize
        }
        return CGSize(
            width: baseSize.width + insets.left + insets.right,
            height: baseSize.height + insets.top + insets.bottom
        )
    }
    
    @objc private func _padding_sizeThatFits(_ size: CGSize) -> CGSize {
        let baseSize = _padding_sizeThatFits(size) // original sizeThatFits
        let insets = padding
        if insets == .zero {
            return baseSize
        }
        return CGSize(
            width: baseSize.width + insets.left + insets.right,
            height: baseSize.height + insets.top + insets.bottom
        )
    }
}


// MARK: - Label with Image
enum LabelImagePosition {
    case left
    case right
}


extension UILabel {
    
    /// Sets an image with text, either on the left or right side.
    /// - Parameters:
    ///   - image: The icon image.
    ///   - text: The text to display.
    ///   - position: .left or .right (default: .left).
    ///   - imageSize: Optional size for the image (defaults to image.size).
    ///   - spacing: Space between image and text.
    func setImage(
        _ image: UIImage?,
        text: String,
        position: LabelImagePosition = .left,
        imageSize: CGSize? = nil,
        spacing: CGFloat = 4
    ) {
        guard let image = image else {
            // No image → fallback to normal text
            self.text = text
            self.attributedText = nil
            return
        }
        
        let attachment = NSTextAttachment()
        attachment.image = image
        
        let size = imageSize ?? image.size
        
        // Vertically align relative to font cap height
        let capHeight = self.font?.capHeight ?? size.height
        let yOffset = (capHeight - size.height) / 2
        
        attachment.bounds = CGRect(
            x: 0,
            y: yOffset,
            width: size.width,
            height: size.height
        )
        
        let imageString = NSAttributedString(attachment: attachment)
        
        let textString = NSAttributedString(
            string: text,
            attributes: [
                .font: self.font as Any,
                .foregroundColor: self.textColor as Any
            ]
        )
        
        // Spacing between image and text using an attributed space
        let spacingString: NSAttributedString
        if spacing > 0 {
            let space = NSMutableAttributedString(string: " ")
            space.addAttribute(.kern, value: spacing, range: NSRange(location: 0, length: space.length))
            spacingString = space
        } else {
            spacingString = NSAttributedString(string: "")
        }
        
        let result = NSMutableAttributedString()
        
        switch position {
        case .left:
            result.append(imageString)
            result.append(spacingString)
            result.append(textString)
        case .right:
            result.append(textString)
            result.append(spacingString)
            result.append(imageString)
        }
        
        self.attributedText = result
    }
}
