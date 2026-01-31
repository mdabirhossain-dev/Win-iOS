//
//
//  AppDelegate.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 8/27/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  © 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .wcBackground
        
        KeychainManager.shared.handleFirstLaunchResetIfNeeded()
        
        UIViewController.installGlobalKeyboardDismissOnOutsideTap()
        KeyboardAvoider.shared.start()
        
        Log.info(KeychainManager.shared.token)
        print(KeychainManager.shared.token)
        
        if KeychainManager.shared.token.isNotEmpty {
//            let navigationController = UINavigationController(rootViewController: TabbarContoller())
            window?.rootViewController = TabbarContoller()
        } else {
            let navigationController = UINavigationController(rootViewController: SignInRouter.createModule())
            window?.rootViewController = navigationController
        }
        
        return true
    }
}

