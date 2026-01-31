//
//
//  UIViewController + Extension.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 9/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

private var associatedKey: UInt8 = 0

extension UIViewController {
    
    // Computed property using associated objects for storing the value
    var viewControllerTitle: String? {
        get {
            return objc_getAssociatedObject(self, &associatedKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &associatedKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

enum TabbarVisibility {
    case show
    case hide
}

extension UIViewController {
    func tabbarVisibility(_ visibility: TabbarVisibility) {
        guard let tabBar = tabBarController as? TabbarContoller else {
            navigationController?.popViewController(animated: true)
            return
        }
        switch visibility {
        case .show:
            tabBar.toggle(hide: false)
        case .hide:
            tabBar.toggle(hide: true)
        }
    }
}
