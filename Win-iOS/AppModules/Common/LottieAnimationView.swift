//
//
//  LottieAnimationView.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/9/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit
import Lottie

final class LottieAnimationViewContainer: UIView {

    private let animationView: LottieAnimationView = {
        let lottie = LottieAnimationView()
        lottie.translatesAutoresizingMaskIntoConstraints = false
        lottie.contentMode = .scaleAspectFit
        lottie.backgroundBehavior = .pauseAndRestore
        return lottie
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.topAnchor.constraint(equalTo: topAnchor),
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            animationView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    func setAnimation(named: LottieFiles,
                      loopMode: LottieLoopMode = .loop,
                      speed: CGFloat = 1.0,
                      autoPlay: Bool = true) {
        animationView.animation = LottieAnimation.named(named.rawValue)
        animationView.loopMode = loopMode
        animationView.animationSpeed = speed
        if autoPlay { animationView.play() }
    }

    func play() { animationView.play() }
    func stopAnimation() { animationView.stop() }
    func pauseAnimation() { animationView.pause() }
}
