//
//
//  OnboardingVC.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/9/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

struct OnboardingModel {
    let image: String
    let title: String
    let description: String
}

class OnboardingVC: UIViewController {
    
    let rootStackView = UIStackView()
    
//    let collectionView = UICollectionView()
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
//    let containerView: UIView = {
//        let lottieView = LottieAnimationViewContainer(frame: CGRect(x: 100, y: 100, width: 200, height: 200))
//        
//        // Set the Lottie animation
//        lottieView.setAnimation(named: .home)
//        return lottieView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(rootStackView)
    }
    
    func setupView() {
        
    }
    
    func layoutView() {
        
    }
}

