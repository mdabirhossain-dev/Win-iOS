//
//
//  AutoSwipingBadgeView.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 8/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

/// A pill-shaped badge that cycles through text items with a swipe animation.
final class AutoSwipingBadgeView: UIView {
    
    // MARK: - Configuration
    struct Configuration {
        var interval: TimeInterval = 3.0
        var animationDuration: TimeInterval = 0.35
        var font: UIFont = .systemFont(ofSize: 13, weight: .medium)
        var textColor: UIColor = .label
        var background: [UIColor] = [.systemGray5, .white]
        var horizontalPadding: CGFloat = 12
        /// If nil, default height is used. Width is always decided by constraints.
        var size: CGSize? = nil
    }
    
    private enum Constants {
        static let defaultHeight: CGFloat = 24
    }
    
    private enum Direction {
        case leftToRight
        case rightToLeft
    }
    
    // MARK: - Public API
    func applyConfiguration(_ configuration: Configuration) {
        self.configuration = configuration
        applyVisualConfiguration()
        invalidateIntrinsicContentSize()
    }
    
    /// Sets the items to rotate through. If items.count <= 1, no animation runs.
    func setItems(_ items: [String]) {
        stopTimer()
        
        self.items = items
        currentIndex = 0
        
        guard let first = items.first else {
            currentLabel.text = nil
            currentLabel.attributedText = nil
            nextLabel.text = nil
            nextLabel.attributedText = nil
            return
        }
        
        // Initial state: index 0 → text only
        configure(label: currentLabel, forIndex: 0, value: first)
        
        nextLabel.text = nil
        nextLabel.attributedText = nil
        nextLabel.alpha = 0
        
        if items.count > 1 {
            startTimerIfNeeded()
        }
    }
    
    // MARK: - Private Properties
    private let currentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var items: [String] = []
    private var currentIndex: Int = 0
    private var timer: Timer?
    private var configuration: Configuration
    
    // MARK: - Init
    init(configuration: Configuration = Configuration()) {
        self.configuration = configuration
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        self.configuration = Configuration()
        super.init(coder: coder)
        commonInit()
    }
    
    // MARK: - UIView Overrides
    override func layoutSubviews() {
        super.layoutSubviews()
        applyCornerRadious(bounds.height / 2)
    }
    
    override var intrinsicContentSize: CGSize {
        let height = configuration.size?.height ?? Constants.defaultHeight
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window == nil {
            stopTimer()
        } else {
            startTimerIfNeeded()
        }
    }
    
    deinit {
        stopTimer()
    }
    
    // MARK: - Setup
    private func commonInit() {
        setupLabels()
        setupLayout()
        applyVisualConfiguration()
    }
    
    private func setupLabels() {
        nextLabel.alpha = 0
        addSubview(currentLabel)
        addSubview(nextLabel)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            currentLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            currentLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            currentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: configuration.horizontalPadding),
            currentLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -configuration.horizontalPadding),
            
            nextLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            nextLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: configuration.horizontalPadding),
            nextLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -configuration.horizontalPadding)
        ])
    }
    
    private func applyVisualConfiguration() {
        applyGradient(colors: configuration.background, direction: .horizontal)
        
        [currentLabel, nextLabel].forEach { label in
            label.font = configuration.font
            label.textColor = configuration.textColor
        }
    }
    
    // MARK: - Content Configuration (index-based)
    /// index == 1 → image + text, otherwise text only
    private func configure(label: UILabel, forIndex index: Int, value: String) {
        let displayText = "\(value)"
        
        if index == 0 {
            // Only 2nd item gets the giftbox
            let icon = UIImage(resource: .giftboxOpen).withTintColor(configuration.textColor)
            label.setImage(icon, text: displayText)
        } else {
            // Explicitly reset attributedText to avoid ghost icons
            label.attributedText = nil
            label.text = displayText
        }
    }
    
    // MARK: - Timer Handling
    private func startTimerIfNeeded() {
        guard items.count > 1, window != nil else { return }
        
        stopTimer()
        
        timer = Timer.scheduledTimer(
            timeInterval: configuration.interval,
            target: self,
            selector: #selector(handleTimerFired),
            userInfo: nil,
            repeats: true
        )
        
        if let timer = timer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc
    private func handleTimerFired() {
        showNextItem(direction: .rightToLeft)
    }
    
    // MARK: - Animation
    private func showNextItem(direction: Direction) {
        guard items.count > 1 else { return }
        
        layoutIfNeeded()
        guard bounds.width > 0 else { return }
        
        let nextIndex = (currentIndex + 1) % items.count
        let nextValue = items[nextIndex]
        
        // Configure next label based on *item index*
        configure(label: nextLabel, forIndex: nextIndex, value: nextValue)
        nextLabel.alpha = 1
        
        prepareNextLabelForAnimation(direction: direction)
        
        performTransitionAnimation(direction: direction) { [weak self] in
            guard let self else { return }
            
            // After animation, current label adopts the *same* item
            self.configure(label: self.currentLabel, forIndex: nextIndex, value: nextValue)
            self.currentLabel.transform = .identity
            self.currentLabel.alpha = 1
            
            // Clean up next label so there’s no leftover icon/text
            self.nextLabel.text = nil
            self.nextLabel.attributedText = nil
            self.nextLabel.transform = .identity
            self.nextLabel.alpha = 0
            
            self.currentIndex = nextIndex
        }
    }
    
    private func prepareNextLabelForAnimation(direction: Direction) {
        let offset = bounds.width
        
        switch direction {
        case .leftToRight:
            nextLabel.transform = CGAffineTransform(translationX: -offset, y: 0)
            nextLabel.alpha = 1
        case .rightToLeft:
            nextLabel.transform = CGAffineTransform(translationX: offset, y: 0)
            nextLabel.alpha = 1
        }
    }
    
    private func performTransitionAnimation(direction: Direction, completion: @escaping () -> Void) {
        let offset = bounds.width
        
        UIView.animate(
            withDuration: configuration.animationDuration,
            delay: 0,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                guard let self else { return }
                
                switch direction {
                case .leftToRight:
                    self.currentLabel.transform = CGAffineTransform(translationX: offset, y: 0)
                    self.currentLabel.alpha = 0
                    self.nextLabel.transform = .identity
                    
                case .rightToLeft:
                    self.currentLabel.transform = CGAffineTransform(translationX: -offset, y: 0)
                    self.currentLabel.alpha = 0
                    self.nextLabel.transform = .identity
                }
            },
            completion: { _ in
                completion()
            }
        )
    }
}
