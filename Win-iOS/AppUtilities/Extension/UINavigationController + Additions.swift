//
//
//  UINavigationController + Additions.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 28/9/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - View Controller Factory
enum ViewControllerType {
    case onboarding
    case signIn
    case signUp
    case forgotPassword
    case otpVerification(userInfo: SignUpUserInfo, otpEvent: OtpEvent)
    case newPassword(msisdn: String, otp: String)
    case tabBar
    case scoreboard
    case home
    case onlineGames(_ gameID: Int)
    case store
    case profileMain
    case updateProfile(_ userInfo: UpdateProfileRequest, avatarUrl: String)
    case totalPoint(_ totalScore: Int)
    case totalScore(_ totalScore: Int)
    case requestPoint(_ userSummery: UserSummaryResponse? = nil)
    case giftPoint(_ userSummery: UserSummaryResponse? = nil)
    case subscriptionHistory
    case helpAndSupport
    case invitation
    case invitationHistory
    case rulesAndRegulations
    case privacyPolicy
    
    func viewController() -> UIViewController {
        var viewController = UIViewController()
        switch self {
        case .onboarding:
            viewController = OnboardingVC()
            return viewController
        case .signIn:
            viewController = SignInRouter.createModule()
            viewController.viewControllerTitle = "সাইন ইন"
            return viewController
        case .signUp:
            viewController = SignUpRouter.createModule()
            viewController.viewControllerTitle = "নিবন্ধন"
            return viewController
        case .forgotPassword:
            viewController = PasswordResetRouter.createModule()
            viewController.viewControllerTitle = "পাসওয়ার্ড রিসেট"
            return viewController
        case .otpVerification(let userInfo, let otpEvent):
            viewController = OtpVerificationRouter.createModule(userInfo: userInfo, otpEvent: otpEvent)
            viewController.viewControllerTitle = "নিবন্ধন"
            return viewController
        case .newPassword(let msisdn, let otp):
            viewController = NewPasswordRouter.createModule(msisdn: msisdn, otp: otp)
            viewController.viewControllerTitle = "নিবন্ধন"
            return viewController
        case .tabBar:
            return TabbarContoller()
        case .scoreboard:
            viewController = ScoreboardRouter.createModule()
            viewController.viewControllerTitle = "স্কোরবোর্ড"
            return viewController
        case .home:
            viewController = HomeRouter.createModule()
            return viewController
        case .onlineGames(let gameID):
            viewController = OnlineGamesViewController(gameID: gameID)
            return viewController
        case .store:
            viewController = StoreRouter.createModule()
            return viewController
        case .profileMain:
            viewController = ProfileRouter.createModule()
            viewController.viewControllerTitle = "প্রোফাইল"
            return viewController
        case .updateProfile(let userInfo, let avatarUrl):
            viewController = UpdateProfileRouter.createModule(userInfo, avatarUrl: avatarUrl)
            viewController.viewControllerTitle = "প্রোফাইল আপডেট করুন"
            return viewController
        case .totalPoint(let totalPoint):
            viewController = TotalPointRouter.createModule(totalPoint)
            viewController.viewControllerTitle = "সর্বমোট পয়েন্ট"
            return viewController
        case .totalScore(let totalScore):
            viewController = TotalScoreRouter.createModule(totalScore)
            viewController.viewControllerTitle = "সর্বমোট স্কোর"
            return viewController
        case .requestPoint(let userSummery):
            viewController = RequestPointViewController(userSummery)
            viewController.viewControllerTitle = "রিকোয়েস্ট পয়েন্ট"
            return viewController
        case .giftPoint(let userSummery):
            viewController = GiftPointRouter.createModule(userSummary: userSummery)// GiftPointViewController(userSummery)
            viewController.viewControllerTitle = "গিফট পয়েন্ট"
            return viewController
        case .subscriptionHistory:
            viewController = SubscriptionHistoryRouter.createModule()
            viewController.viewControllerTitle = "পয়েন্ট হিস্ট্রি"
            return viewController
        case .helpAndSupport:
            viewController = HelpAndSupportRouter.createModule()
            viewController.viewControllerTitle = "হেল্প এবং সাপোর্ট"
            return viewController
        case .invitation:
            viewController = InvitationRouter.createModule()
            viewController.viewControllerTitle = "ইনভাইট"
            return viewController
        case .invitationHistory:
            viewController = InvitationHistoryRouter.createModule()
            viewController.viewControllerTitle = "ইনভাইট হিস্ট্রি"
            return viewController
        case .rulesAndRegulations:
            viewController = RulesAndRegulationsViewController()
            viewController.viewControllerTitle = "নিয়ম ও শর্তাবলী"
            return viewController
        case .privacyPolicy:
            viewController = PrivacyPolicyViewController()
            viewController.viewControllerTitle = "প্রাইভেসি পলিসি"
            return viewController
        }
    }
}

// MARK: - Key Window Helper
private extension UIApplication {
    static var keyWindowSafe: UIWindow? {
        return shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow }) ?? shared.windows.first
    }
}

// MARK: - Root View Controller Setter
private extension UIWindow {
    func setRoot(_ viewController: UIViewController?, animated: Bool = true, duration: TimeInterval = 0.3) {
        guard let vc = viewController else { return }
        DispatchQueue.main.async {
            guard animated, let snapshot = self.snapshotView(afterScreenUpdates: true) else {
                self.rootViewController = vc
                self.makeKeyAndVisible()
                return
            }
            vc.view.addSubview(snapshot)
            self.rootViewController = vc
            self.makeKeyAndVisible()
            UIView.animate(withDuration: duration, animations: {
                snapshot.alpha = 0
                snapshot.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
            }, completion: { _ in snapshot.removeFromSuperview() })
        }
    }
}

// MARK: - UINavigationController Helpers
extension UINavigationController {
    
    func pushViewController(_ type: ViewControllerType, animated: Bool = true) {
        pushViewController(type.viewController(), animated: animated)
    }
    
    func setViewControllers(_ type: ViewControllerType, animated: Bool = true, embedInNav: Bool = false) {
        let vc = type.viewController()
        let root = embedInNav ? UINavigationController(rootViewController: vc) : vc
        
        if let window = UIApplication.keyWindowSafe {
            window.setRoot(root, animated: animated)
            return
        }
        
        // Create new window if no keyWindow exists
        DispatchQueue.main.async {
            if let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) {
                let window = UIWindow(windowScene: scene)
                window.rootViewController = root
                window.makeKeyAndVisible()
                return
            }
        }
    }
    
    func popToViewController(_ type: ViewControllerType, animated: Bool = true) {
        let targetType: AnyClass = type.viewController().classForCoder
        if let target = viewControllers.first(where: { $0.isKind(of: targetType) }) {
            popToViewController(target, animated: animated)
        }
    }
    
    func logoutAndGoToSignIn(animated: Bool = true) {
        KeychainManager.shared.deleteAuth(token: true)
        
        KeychainManager.shared.debugDumpAuth()
        
        let signInVC = ViewControllerType.signIn.viewController()
        let nav = UINavigationController(rootViewController: signInVC)
        UIApplication.keyWindowSafe?.setRoot(nav, animated: animated)
    }
    
    func resetWindow(with viewController: UIViewController?, animated: Bool = false) {
        UIApplication.keyWindowSafe?.setRoot(viewController, animated: animated)
    }
    
    func resetWindow(with navController: UINavigationController?, animated: Bool = false) {
        UIApplication.keyWindowSafe?.setRoot(navController, animated: animated)
    }
}
