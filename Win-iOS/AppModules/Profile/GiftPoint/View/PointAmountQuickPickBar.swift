//
//
//  PointAmountQuickPickBar.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 1/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - NEW: PointAmountQuickPickBar (no selection UI, always white, starCircle icon)
public final class PointAmountQuickPickBar: UIView {

    public var onValueTapped: ((Int) -> Void)?

    private var values: [Int] = []

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false

        // ✅ make taps reliable inside scrollview
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true

        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    private var itemViews: [PointAmountQuickPickItemView] = []

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)
        scrollView.addSubview(stackView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),

            stackView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor)
        ])
    }

    public func setValues(_ values: [Int]) {
        self.values = values
        rebuildItems()
    }

    private func rebuildItems() {
        itemViews.forEach { $0.removeFromSuperview() }
        itemViews.removeAll()

        for (index, value) in values.enumerated() {
            let itemView = PointAmountQuickPickItemView(title: "\(value)")
            itemView.tag = index

            itemView.addTarget(self, action: #selector(didTapItemView(_:)), for: .touchUpInside)

            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapItemViewWithGesture(_:)))
            tapGestureRecognizer.cancelsTouchesInView = false
            itemView.addGestureRecognizer(tapGestureRecognizer)

            stackView.addArrangedSubview(itemView)
            itemViews.append(itemView)
        }
    }

    @objc private func didTapItemView(_ sender: PointAmountQuickPickItemView) {
        let index = sender.tag
        guard values.indices.contains(index) else { return }
        onValueTapped?(values[index])
    }

    @objc private func didTapItemViewWithGesture(_ sender: UITapGestureRecognizer) {
        guard let itemView = sender.view as? PointAmountQuickPickItemView else { return }
        let index = itemView.tag
        guard values.indices.contains(index) else { return }
        onValueTapped?(values[index])
    }
}

// MARK: - NEW: Quick pick item (always white, starCircle icon, no selected state)
private final class PointAmountQuickPickItemView: UIControl {

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .starCircle))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .winFont(.semiBold, size: .small)
        label.textColor = .black
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()

    init(title: String) {
        super.init(frame: .zero)
        setupView(title: title)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(title: "")
    }

    private func setupView(title: String) {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true

        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)
        
        backgroundColor = .white
        applyCornerRadious(14, borderWidth: 1, borderColor: .systemGray4)


        titleLabel.text = title.toBanglaNumberWithSuffix()

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 28),
            
            imageView.widthAnchor.constraint(equalToConstant: 16),
            imageView.heightAnchor.constraint(equalToConstant: 16),

            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}
