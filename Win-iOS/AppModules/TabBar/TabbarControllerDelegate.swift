//
//
//  TabbarControllerDelegate.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 30/9/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//

import UIKit
import Lottie

protocol TabbarControllerDelegate: AnyObject {
    func did(selectedIndex: Int)
}

class TabbarContoller: UITabBarController {
    
    weak var tabbarDelegate: TabbarControllerDelegate?
    
    let floatingTabbarView = FloatingBarView(TabbarItems.allCases)
    private let buttonSize: CGFloat = 44.0
    private let selectedIndexForButton: Int = 1
    
    // MARK: - Lottie Animation View for Center Button
    private let lottieView: LottieAnimationView = {
        let animationView = LottieAnimationView(name: "Home")
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    // Transparent button to handle taps over the Lottie view
    private let midButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = 44 / 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.masksToBounds = false
        return button
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            createNavViewController(viewController: ScoreboardRouter.createModule()),
            createNavViewController(viewController: HomeRouter.createModule()),
            createNavViewController(viewController: ProfileRouter.createModule())
        ]
        
        tabBar.isHidden = true
        setupFloatingTabBar()
        setupFloatingButton()
        
        selectedIndex = selectedIndexForButton
        floatingTabbarView.updateUI(selectedIndex: selectedIndexForButton)
    }
    
    private func createNavViewController(viewController: UIViewController) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
//        navController.navigationBar.prefersLargeTitles = false
        return navController
    }
    
    // MARK: - Floating Tabbar Setup
    private func setupFloatingTabBar() {
        floatingTabbarView.delegate = self
        view.addSubview(floatingTabbarView)
        floatingTabbarView.centerXInSuperview()
        
        NSLayoutConstraint.activate([
            floatingTabbarView.heightAnchor.constraint(equalToConstant: 58),
            floatingTabbarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            floatingTabbarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            floatingTabbarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])
    }
    
    // MARK: - Floating Button + Lottie Setup
    private func setupFloatingButton() {
        view.insertSubview(bottomView, aboveSubview: tabBar)
        view.insertSubview(lottieView, aboveSubview: bottomView)
        view.insertSubview(midButton, aboveSubview: lottieView)
        
        midButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            midButton.widthAnchor.constraint(equalToConstant: buttonSize),
            midButton.heightAnchor.constraint(equalToConstant: buttonSize),
            midButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            midButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -36),
            
            lottieView.centerXAnchor.constraint(equalTo: midButton.centerXAnchor),
            lottieView.centerYAnchor.constraint(equalTo: midButton.centerYAnchor),
            lottieView.widthAnchor.constraint(equalToConstant: buttonSize),
            lottieView.heightAnchor.constraint(equalToConstant: buttonSize),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.topAnchor.constraint(equalTo: floatingTabbarView.bottomAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func buttonTapped(_ sender: UIButton) {
        Log.info("Center button tapped!")
        sender.pulse() // Your custom pulse animation
        lottieView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce)
        
        self.selectedIndex = selectedIndexForButton
        self.tabbarDelegate?.did(selectedIndex: selectedIndexForButton)
//        floatingTabbarView.titleLabel.textColor = UIColor(hex: 0xD00234, alpha: 0.9)
        floatingTabbarView.updateUI(selectedIndex: selectedIndexForButton)
    }
    
    // MARK: - External Controls
    func toggle(hide: Bool) {
        floatingTabbarView.toggle(hide: hide)
        midButton.isHidden = hide
        bottomView.isHidden = hide
        lottieView.isHidden = hide
    }
    
    func chanageTabbar(for index: Int) {
        selectedIndex = index
        floatingTabbarView.updateUI(selectedIndex: index)
        
        if index == selectedIndexForButton {
            playCenterLoopAnimation(true)
        } else {
            playCenterLoopAnimation(false)
        }
    }
    
    // MARK: - Animation Helpers
    private func playCenterLoopAnimation(_ shouldPlay: Bool) {
        if shouldPlay {
            lottieView.loopMode = .playOnce
            lottieView.play()
        } else {
            lottieView.stop()
        }
    }
}

// MARK: - FloatingBarViewDelegate
extension TabbarContoller: FloatingBarViewDelegate {
    func did(selectindex: Int) {
        selectedIndex = selectindex
        tabbarDelegate?.did(selectedIndex: selectindex)
        
        if selectindex == selectedIndexForButton {
            midButton.pulse()
            lottieView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce)
        } else {
            lottieView.stop()
        }
    }
}

