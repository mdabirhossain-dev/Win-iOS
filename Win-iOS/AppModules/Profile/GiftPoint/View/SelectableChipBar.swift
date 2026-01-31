//
//
//  SelectableChipBar.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 1/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - SelectableChipBar (generic, reusable, single-select)
public final class SelectableChipBar<Item>: UIView {

    public var onSelectionChanged: ((Item, Int) -> Void)?

    public private(set) var selectedIndex: Int?
    public var selectedItem: Item? {
        guard let selectedIndex = selectedIndex, items.indices.contains(selectedIndex) else { return nil }
        return items[selectedIndex]
    }

    private var items: [Item] = []
    private var titleProvider: ((Item) -> String)?

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false

        // ✅ THIS is what makes your taps reliable
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

    private var chipViews: [SelectableChipBarItemView] = []

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
            heightAnchor.constraint(equalToConstant: 28),

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

    public func setItems(_ items: [Item],
                         selectedIndex: Int? = 0,
                         titleProvider: @escaping (Item) -> String) {
        self.items = items
        self.titleProvider = titleProvider
        rebuildChips()

        if let selectedIndex = selectedIndex, items.indices.contains(selectedIndex) {
            select(index: selectedIndex, animated: false, notify: false)
        } else {
            self.selectedIndex = nil
        }
    }

    public func select(index: Int, animated: Bool = true, notify: Bool = true) {
        guard items.indices.contains(index) else { return }

        if let previousIndex = selectedIndex, previousIndex != index, chipViews.indices.contains(previousIndex) {
            chipViews[previousIndex].isSelected = false
        }

        selectedIndex = index

        let selectedChipView = chipViews[index]
        selectedChipView.isSelected = true

        let targetRect = selectedChipView.convert(selectedChipView.bounds, to: scrollView)
        scrollView.scrollRectToVisible(targetRect.insetBy(dx: -16, dy: 0), animated: animated)

        if notify {
            onSelectionChanged?(items[index], index)
        }
    }

    private func rebuildChips() {
        chipViews.forEach { $0.removeFromSuperview() }
        chipViews.removeAll()

        let titleProvider = self.titleProvider ?? { _ in "" }

        for (index, item) in items.enumerated() {
            let chipView = SelectableChipBarItemView(title: titleProvider(item))
            chipView.tag = index

            // ✅ Still keep UIControl target
            chipView.addTarget(self, action: #selector(didTapChipView(_:)), for: .touchUpInside)

            // ✅ EXTRA: tap gesture to make it bulletproof inside scroll views
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapChipViewWithGesture(_:)))
            tapGestureRecognizer.cancelsTouchesInView = false
            chipView.addGestureRecognizer(tapGestureRecognizer)

            stackView.addArrangedSubview(chipView)
            chipViews.append(chipView)
        }
    }

    @objc private func didTapChipView(_ sender: SelectableChipBarItemView) {
        select(index: sender.tag, animated: true, notify: true)
    }

    @objc private func didTapChipViewWithGesture(_ sender: UITapGestureRecognizer) {
        guard let chipView = sender.view as? SelectableChipBarItemView else { return }
        select(index: chipView.tag, animated: true, notify: true)
    }
}

// MARK: - Single chip view (image + label, spacing 8, height 24, width = content)
private final class SelectableChipBarItemView: UIControl {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .winFont(.regular, size: .small)
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

    override var isSelected: Bool {
        didSet { updateAppearance() }
    }

    init(title: String) {
        super.init(frame: .zero)
        setupView(title: title)
        updateAppearance()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(title: "")
        updateAppearance()
    }

    private func setupView(title: String) {
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true

        // ✅ These priorities stop weird sizing / zero-touch-area issues
        setContentHuggingPriority(.required, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .horizontal)

        heightAnchor.constraint(equalToConstant: 28).isActive = true

        applyCornerRadious(14)

        titleLabel.text = title

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),

            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }

    private func updateAppearance() {
        if isSelected {
            backgroundColor = .wcPinkLight
            imageView.image = UIImage(systemName: "record.circle")
            imageView.tintColor = .wcVelvet
            titleLabel.textColor = .wcVelvet
        } else {
            backgroundColor = .systemGray5
            imageView.image = UIImage(systemName: "circle")
            imageView.tintColor = .systemGray
            titleLabel.textColor = .black
        }
    }
}
