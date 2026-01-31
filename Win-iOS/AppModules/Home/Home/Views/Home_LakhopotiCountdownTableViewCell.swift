//
//
//  HomeLakhopotiCountdownTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 19/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class HomeLakhopotiCountdownTableViewCell: UITableViewCell {

    // MARK: - UI
    private let rootStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .winFont(.regular, size: .medium)
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .winFont(.bold, size: .medium)
        label.textAlignment = .center
        return label
    }()

    private let countdownBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray3.withAlphaComponent(0.3)
        view.applyCornerRadious(12)
        return view
    }()

    private let countdownStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 0
        return stackView
    }()

    private let daysValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .winFont(.bold, size: .large)
        label.textAlignment = .center
        label.text = "০"
        return label
    }()

    private let daysUnitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .winFont(.regular, size: .small)
        label.textAlignment = .center
        label.text = "দিন"
        return label
    }()

    private let hoursValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .winFont(.bold, size: .large)
        label.textAlignment = .center
        label.text = "০০"
        return label
    }()

    private let hoursUnitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .winFont(.regular, size: .small)
        label.textAlignment = .center
        label.text = "ঘন্টা"
        return label
    }()

    private let minutesValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .winFont(.bold, size: .large)
        label.textAlignment = .center
        label.text = "০০"
        return label
    }()

    private let minutesUnitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .winFont(.regular, size: .small)
        label.textAlignment = .center
        label.text = "মিনিট"
        return label
    }()

    private let secondsValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .winFont(.bold, size: .large)
        label.textAlignment = .center
        label.text = "০০"
        return label
    }()

    private let secondsUnitLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .winFont(.regular, size: .small)
        label.textAlignment = .center
        label.text = "সেকেন্ড"
        return label
    }()

    private let separator1View: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private let separator2View: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private let separator3View: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    private var daysStackView: UIStackView?
    private var hoursStackView: UIStackView?
    private var minutesStackView: UIStackView?
    private var secondsStackView: UIStackView?

    // MARK: - Timer / Time
    private var timer: Timer?
    private var targetDate: Date?
    private var serverTimeOffset: TimeInterval = 0

    // MARK: - Animation
    private var lastSecondsText: String = ""

    /// Toggle which animation you want
    private enum SecondsAnimationStyle {
        case ticker
        case pulse
    }

    private let secondsAnimationStyle: SecondsAnimationStyle = .ticker

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit { stopTimer() }

    // MARK: - Setup
    private func setupView() {
        selectionStyle = .none

        contentView.backgroundColor = .wcPink
        contentView.applyCornerRadious(12)
        contentView.applyShadow()

        contentView.addSubview(rootStackView)
        rootStackView.addArrangedSubviews([titleLabel, descriptionLabel, countdownBackgroundView])

        countdownBackgroundView.addSubview(countdownStackView)
        countdownBackgroundView.addSubview(separator1View)
        countdownBackgroundView.addSubview(separator2View)
        countdownBackgroundView.addSubview(separator3View)

        let days = makeCountdownUnitStack(valueLabel: daysValueLabel, unitLabel: daysUnitLabel)
        let hours = makeCountdownUnitStack(valueLabel: hoursValueLabel, unitLabel: hoursUnitLabel)
        let minutes = makeCountdownUnitStack(valueLabel: minutesValueLabel, unitLabel: minutesUnitLabel)
        let seconds = makeCountdownUnitStack(valueLabel: secondsValueLabel, unitLabel: secondsUnitLabel)

        daysStackView = days
        hoursStackView = hours
        minutesStackView = minutes
        secondsStackView = seconds

        countdownStackView.addArrangedSubview(days)
        countdownStackView.addArrangedSubview(hours)
        countdownStackView.addArrangedSubview(minutes)
        countdownStackView.addArrangedSubview(seconds)

        NSLayoutConstraint.activate([
            rootStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            rootStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rootStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rootStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),

            countdownBackgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: 56),

            countdownStackView.topAnchor.constraint(equalTo: countdownBackgroundView.topAnchor, constant: 8),
            countdownStackView.leadingAnchor.constraint(equalTo: countdownBackgroundView.leadingAnchor, constant: 16),
            countdownStackView.trailingAnchor.constraint(equalTo: countdownBackgroundView.trailingAnchor, constant: -16),
            countdownStackView.bottomAnchor.constraint(equalTo: countdownBackgroundView.bottomAnchor, constant: -8),

            separator1View.widthAnchor.constraint(equalToConstant: 1),
            separator2View.widthAnchor.constraint(equalToConstant: 1),
            separator3View.widthAnchor.constraint(equalToConstant: 1),

            separator1View.heightAnchor.constraint(equalToConstant: 34),
            separator2View.heightAnchor.constraint(equalToConstant: 34),
            separator3View.heightAnchor.constraint(equalToConstant: 34),

            separator1View.centerYAnchor.constraint(equalTo: countdownStackView.centerYAnchor),
            separator2View.centerYAnchor.constraint(equalTo: countdownStackView.centerYAnchor),
            separator3View.centerYAnchor.constraint(equalTo: countdownStackView.centerYAnchor),
        ])

        if let hoursStackView, let minutesStackView, let secondsStackView {
            NSLayoutConstraint.activate([
                separator1View.leadingAnchor.constraint(equalTo: hoursStackView.leadingAnchor),
                separator2View.leadingAnchor.constraint(equalTo: minutesStackView.leadingAnchor),
                separator3View.leadingAnchor.constraint(equalTo: secondsStackView.leadingAnchor),
            ])
        }
    }

    private func makeCountdownUnitStack(valueLabel: UILabel, unitLabel: UILabel) -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: [valueLabel, unitLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()

        stopTimer()
        targetDate = nil
        serverTimeOffset = 0
        lastSecondsText = ""

        titleLabel.text = nil
        descriptionLabel.text = nil

        daysValueLabel.text = "০"
        hoursValueLabel.text = "০০"
        minutesValueLabel.text = "০০"
        secondsValueLabel.text = "০০"

        secondsValueLabel.alpha = 1.0
        secondsValueLabel.transform = .identity
        secondsValueLabel.layer.shadowOpacity = 0
        secondsValueLabel.layer.shadowRadius = 0
        secondsValueLabel.layer.shadowColor = nil
        secondsValueLabel.layer.shadowOffset = .zero
    }

    // MARK: - Configure
    func configure(_ lakhopoti: Lakhopoti?) {
        titleLabel.text = lakhopoti?.title
        descriptionLabel.text = "ক্যাম্পেইন শুরু হতে বাকি"

        guard let lakhopoti else { return }

        let serverNow = parseDate(from: lakhopoti.currentTime)
        let startDate = parseDate(from: lakhopoti.startDate)

        if let serverNow, let startDate {
            serverTimeOffset = serverNow.timeIntervalSince(Date())
            targetDate = startDate
            updateCountdown()
            startTimer()
        } else {
            targetDate = nil
        }
    }

    // MARK: - Timer
    private func startTimer() {
        stopTimer()
        let t = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
        timer = t
        RunLoop.main.add(t, forMode: .common)
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // MARK: - Animations
    private func animateTicker(_ label: UILabel, newText: String) {
        guard label.text != newText else { return }

        let oldText = label.text
        let parent = label.superview ?? contentView

        let ghostLabel = UILabel()
        ghostLabel.translatesAutoresizingMaskIntoConstraints = false
        ghostLabel.text = oldText
        ghostLabel.textColor = label.textColor
        ghostLabel.font = label.font
        ghostLabel.textAlignment = label.textAlignment
        ghostLabel.alpha = 1.0

        parent.addSubview(ghostLabel)

        NSLayoutConstraint.activate([
            ghostLabel.centerXAnchor.constraint(equalTo: label.centerXAnchor),
            ghostLabel.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            ghostLabel.widthAnchor.constraint(equalTo: label.widthAnchor),
            ghostLabel.heightAnchor.constraint(equalTo: label.heightAnchor)
        ])

        label.text = newText
        label.transform = CGAffineTransform(translationX: 0, y: label.bounds.height * 0.7)
        label.alpha = 0.0

        UIView.animate(withDuration: 0.22,
                       delay: 0,
                       options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction]) {
            ghostLabel.transform = CGAffineTransform(translationX: 0, y: -label.bounds.height * 0.7)
            ghostLabel.alpha = 0.0

            label.transform = .identity
            label.alpha = 1.0
        } completion: { _ in
            ghostLabel.removeFromSuperview()
        }
    }

    private func animatePulse(_ label: UILabel, newText: String) {
        guard label.text != newText else { return }

        label.text = newText
        label.layer.removeAllAnimations()
        label.transform = .identity

        let originalShadowOpacity = label.layer.shadowOpacity
        let originalShadowRadius = label.layer.shadowRadius
        let originalShadowColor = label.layer.shadowColor
        let originalShadowOffset = label.layer.shadowOffset

        label.layer.shadowColor = UIColor.white.cgColor
        label.layer.shadowOffset = .zero
        label.layer.shadowOpacity = 0.0
        label.layer.shadowRadius = 0

        UIView.animate(withDuration: 0.12,
                       delay: 0,
                       options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction]) {
            label.transform = CGAffineTransform(scaleX: 1.08, y: 1.08)
            label.layer.shadowOpacity = 0.9
            label.layer.shadowRadius = 8
        } completion: { _ in
            UIView.animate(withDuration: 0.18,
                           delay: 0,
                           options: [.curveEaseIn, .beginFromCurrentState, .allowUserInteraction]) {
                label.transform = .identity
                label.layer.shadowOpacity = originalShadowOpacity
                label.layer.shadowRadius = originalShadowRadius
                label.layer.shadowColor = originalShadowColor
                label.layer.shadowOffset = originalShadowOffset
            }
        }
    }

    // MARK: - Countdown
    private func updateCountdown() {
        guard let targetDate else { return }

        let serverNowApprox = Date().addingTimeInterval(serverTimeOffset)
        let remaining = max(0, targetDate.timeIntervalSince(serverNowApprox))

        let totalSeconds = Int(remaining)
        let days = totalSeconds / 86_400
        let hours = (totalSeconds % 86_400) / 3_600
        let minutes = (totalSeconds % 3_600) / 60
        let seconds = totalSeconds % 60

        let daysText = "\(days)".toBanglaNumberWithSuffix()
        let hoursText = twoDigitsString(hours).toBanglaNumberWithSuffix()
        let minutesText = twoDigitsString(minutes).toBanglaNumberWithSuffix()
        let secondsText = twoDigitsString(seconds).toBanglaNumberWithSuffix()
        
        if lastSecondsText != secondsText {
            lastSecondsText = secondsText

            switch secondsAnimationStyle {
            case .ticker:
                animateTicker(daysValueLabel, newText: daysText)
                animateTicker(hoursValueLabel, newText: hoursText)
                animateTicker(minutesValueLabel, newText: minutesText)
                animateTicker(secondsValueLabel, newText: secondsText)
            case .pulse:
                animatePulse(daysValueLabel, newText: daysText)
                animatePulse(hoursValueLabel, newText: hoursText)
                animatePulse(minutesValueLabel, newText: minutesText)
                animatePulse(secondsValueLabel, newText: secondsText)
            }
        }

        if remaining <= 0 { stopTimer() }
    }

    private func twoDigitsString(_ value: Int) -> String {
        value < 10 ? "0\(value)" : "\(value)"
    }

    // MARK: - Date Parsing
    private func parseDate(from string: String?) -> Date? {
        guard let string, !string.isEmpty else { return nil }

        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = iso.date(from: string) { return date }

        iso.formatOptions = [.withInternetDateTime]
        if let date = iso.date(from: string) { return date }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Dhaka")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter.date(from: string)
    }
}
