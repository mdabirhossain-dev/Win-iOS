//
//
//  ProfileUserProgressCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 9/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class ProfileUserProgressCell: UICollectionViewCell {

    // MARK: - UI (kept same structure)
    private let rootStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let progressView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let progressBarView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        view.applyCornerRadious(2)
        return view
    }()

    private let progressImageStackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        return stack
    }()

    private let nextStepStackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let nextStepButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("পরবর্তী ধাপ >", for: .normal)
        button.setTitleColor(.wcVelvet, for: .normal)
        button.titleLabel?.font = .winFont(.semiBold, size: .small)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let pointsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .winFont(.regular, size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Step views (fixed 3)
    private var stepViews: [ProgressStepView] = []

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        stepViews.forEach { $0.apply(isCompleted: false) }
        // don't wipe pointsLabel unless you want
    }

    // MARK: - Setup
    private func setupView() {
        contentView.backgroundColor = .clear
        contentView.applyShadow()
        contentView.applyCornerRadious(16, borderWidth: 1, borderColor: .systemGray4)

        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubviews([progressView, nextStepStackView])

        progressView.addSubviews([progressBarView, progressImageStackView])
        nextStepStackView.addArrangedSubviews([nextStepButton, pointsLabel])

        // IMPORTANT: original icons are tied to title (as you requested)
        let s1 = ProgressStepView(title: "সাইন আপ",  originalIconName: "success")
        let s2 = ProgressStepView(title: "প্রোফাইল", originalIconName: "winProfile")
        let s3 = ProgressStepView(title: "ইনভাইট",   originalIconName: "inviteUser")
        stepViews = [s1, s2, s3]
        
        progressImageStackView.addArrangedSubviews(stepViews)

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            progressView.leadingAnchor.constraint(equalTo: rootStackView.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor),

            progressBarView.heightAnchor.constraint(equalToConstant: 4),
            progressBarView.leadingAnchor.constraint(equalTo: progressView.leadingAnchor, constant: 16),
            progressBarView.trailingAnchor.constraint(equalTo: progressView.trailingAnchor, constant: -16),
            progressBarView.bottomAnchor.constraint(equalTo: progressView.bottomAnchor, constant: -26),

            progressImageStackView.centerXAnchor.constraint(equalTo: progressView.centerXAnchor),
            progressImageStackView.centerYAnchor.constraint(equalTo: progressView.centerYAnchor),
            progressImageStackView.leadingAnchor.constraint(equalTo: progressView.leadingAnchor),
            progressImageStackView.trailingAnchor.constraint(equalTo: progressView.trailingAnchor),
        ])
    }

    // MARK: - External Configure
    /// Configure only journey status.
    func configure(journey: ProfileJourneyViewModel?, pointsText: String? = nil) {
        if let pointsText {
            pointsLabel.text = pointsText
        }

        let vm = journey ?? .empty

        for (idx, stepView) in stepViews.enumerated() {
            let completed = vm.steps.indices.contains(idx) ? vm.steps[idx].isCompleted : false
            stepView.apply(isCompleted: completed)
        }
    }
}

// MARK: - Step View
private final class ProgressStepView: UIView {

    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .winFont(.regular, size: .extraSmall)
        return label
    }()
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.applyShadow()
        imageView.applyCornerRadious(16)
        return imageView
    }()
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 6
        return stackView
    }()

    private var originalIconName: String

    init(title: String, originalIconName: String) {
        self.originalIconName = originalIconName
        super.init(frame: .zero)
        setup(title: title)
        apply(isCompleted: false)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(title: String) {
        titleLabel.text = title

        addSubview(stackView)
        stackView.addArrangedSubviews([titleLabel, imageView])

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            imageView.heightAnchor.constraint(equalToConstant: 32),
            imageView.widthAnchor.constraint(equalToConstant: 32)
        ])
    }

    func apply(isCompleted: Bool) {
        if isCompleted {
            imageView.image = UIImage(systemName: "checkmark.circle.fill")
            imageView.tintColor = .wcGreen
            imageView.contentMode = .scaleAspectFit
            titleLabel.textColor = .label
        } else {
            imageView.image = UIImage(named: originalIconName)
            imageView.tintColor = .black   // keep your old tint behavior
            imageView.contentMode = .center
            titleLabel.textColor = .gray
        }
    }
}
