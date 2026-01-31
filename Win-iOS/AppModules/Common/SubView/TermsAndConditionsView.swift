//
//
//  TermsAndConditionsView.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 29/9/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class TermsAndConditionsView: UIView {

    // MARK: - Public API
    var onLinkTap: ((String) -> Void)?

    var fullText: String = "" {
        didSet { applyText() }
    }

    /// Array of (visibleText, urlString)
    var links: [(String, String)] = [] {
        didSet { applyText() }
    }

    // MARK: - UI
    private let textView: UITextView = {
        let tv = UITextView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isEditable = false
        tv.isSelectable = true
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        tv.dataDetectorTypes = [] // we'll insert links ourselves
        return tv
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        textView.delegate = self
        // Default appearance
        textView.typingAttributes = [
            .font: UIFont.winFont(.regular, size: .extraSmall),
            .foregroundColor: UIColor.label
        ]
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.wcVelvet, // your green
//            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
    }

    private func applyText() {
        let baseFont = UIFont.winFont(.regular, size: .extraSmall)
        let baseColor = UIColor.label

        let attr = NSMutableAttributedString(
            string: fullText,
            attributes: [.font: baseFont, .foregroundColor: baseColor]
        )

        // Apply link attributes for ALL occurrences of each linkText
        for (linkText, urlString) in links {
            let search = fullText as NSString
            var searchRange = NSRange(location: 0, length: search.length)
            while true {
                let found = search.range(of: linkText, options: [], range: searchRange)
                if found.location == NSNotFound { break }
                attr.addAttributes([
                    .link: urlString,
                    .foregroundColor: UIColor.wcGreen,
//                    .underlineStyle: NSUnderlineStyle.single.rawValue
                ], range: found)

                let nextLocation = found.location + found.length
                if nextLocation >= search.length { break }
                searchRange = NSRange(location: nextLocation, length: search.length - nextLocation)
            }
        }

        textView.attributedText = attr
        // Make sure voiceover reads it as static text with links
        textView.accessibilityTraits = [.staticText]
    }
}

extension TermsAndConditionsView: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        onLinkTap?(URL.absoluteString)
        return false // we handled it
    }
}
