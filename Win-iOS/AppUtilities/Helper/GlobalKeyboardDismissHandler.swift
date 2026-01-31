//
//
//  GlobalKeyboardDismissHandler.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 23/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit
import ObjectiveC.runtime

private var _globalKbdDismissInstalledKey: UInt8 = 0
private var _globalKbdDismissOptOutKey: UInt8 = 0

public extension UIViewController {

    /// Set `true` on a specific VC if you want to disable the global behavior for that screen.
    var disablesGlobalKeyboardDismissOnOutsideTap: Bool {
        get { (objc_getAssociatedObject(self, &_globalKbdDismissOptOutKey) as? Bool) ?? false }
        set { objc_setAssociatedObject(self, &_globalKbdDismissOptOutKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// Call ONCE from AppDelegate/SceneDelegate
    static func installGlobalKeyboardDismissOnOutsideTap() {
        // Run once
        guard objc_getAssociatedObject(self, &_globalKbdDismissInstalledKey) == nil else { return }
        objc_setAssociatedObject(self, &_globalKbdDismissInstalledKey, true, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

        let original = #selector(UIViewController.viewDidLoad)
        let swizzled = #selector(UIViewController._kbdDismiss_swizzled_viewDidLoad)

        guard
            let originalMethod = class_getInstanceMethod(UIViewController.self, original),
            let swizzledMethod = class_getInstanceMethod(UIViewController.self, swizzled)
        else { return }

        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    @objc private func _kbdDismiss_swizzled_viewDidLoad() {
        // Calls the original viewDidLoad (because swapped)
        _kbdDismiss_swizzled_viewDidLoad()

        // Only apply to your app's VCs (avoid UIKit/system controllers)
        let isFromMainBundle = Bundle(for: type(of: self)) == .main
        guard isFromMainBundle else { return }

        // Opt-out per VC if needed
        guard disablesGlobalKeyboardDismissOnOutsideTap == false else { return }

        // Install your gesture (your existing method)
        enableKeyboardDismissOnOutsideTap()
    }
}


//// Call it once
//func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//    UIViewController.installGlobalKeyboardDismissOnOutsideTap()
//    return true
//}

//// or
//func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//    UIViewController.installGlobalKeyboardDismissOnOutsideTap()
//}

//// Opt out on a specific screen (rare)
//final class CameraVC: UIViewController {
//    override func viewDidLoad() {
//        disablesGlobalKeyboardDismissOnOutsideTap = true
//        super.viewDidLoad()
//    }
//}
