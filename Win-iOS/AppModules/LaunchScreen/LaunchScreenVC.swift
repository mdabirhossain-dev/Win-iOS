//
//
//  LaunchScreenVC.swift
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

class LaunchScreenVC: UIViewController {

    @IBOutlet weak var launchAnimationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchAnimationView.animationSpeed = 1
        launchAnimationView.play()
    }
}
