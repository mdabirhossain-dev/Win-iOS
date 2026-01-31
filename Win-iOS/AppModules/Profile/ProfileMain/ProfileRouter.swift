//
//  ProfileRouter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 11/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class ProfileRouter: ProfileRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = ProfileViewController()

        let presenter = ProfilePresenter()
        let interactor = ProfileInteractor()
        let router = ProfileRouter()

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter
        router.viewController = view

        return view
    }

    func dismissToHomeTab(from vc: UIViewController) {
        guard let tabBar = vc.tabBarController as? TabbarContoller else { return }
        tabBar.chanageTabbar(for: 1)
    }

    func navigate(to destination: ProfileRoute, from navigationController: UINavigationController?) {
        switch destination {
        case .updateProfile(let userInfo, let avatarUrl):
            navigationController?.pushViewController(.updateProfile(userInfo, avatarUrl: avatarUrl))
        case .totalPoint(let totalPoint):
            navigationController?.pushViewController(.totalPoint(totalPoint))
        case .totalScore(let totalScore):
            navigationController?.pushViewController(.totalScore(totalScore))
        case .requestPoint(let userSummery):
            navigationController?.pushViewController(.requestPoint(userSummery))
        case .giftPoint(let userSummery):
            navigationController?.pushViewController(.giftPoint(userSummery))
        case .subscriptionHistory:
            navigationController?.pushViewController(.subscriptionHistory)
        case .helpAndSupport:
            navigationController?.pushViewController(.helpAndSupport)
        case .invite:
            navigationController?.pushViewController(.invitation)
        case .rulesAndRegulations:
            navigationController?.pushViewController(.rulesAndRegulations)
        case .privacyPolicy:
            navigationController?.pushViewController(.privacyPolicy)
        }
    }

    func showRatePrompt() {
        Alert.show(
            AlertConfig(
                title: "আপনার মতামত অত্যন্ত গুরুত্বপূর্ণ",
                message: "৫ স্টার রেটিং দিয়ে আমাদের সাপোর্ট করুন",
                icon: .image(UIImage(resource: .winAppIcon)),
                buttons: .yesNo(yesTitle: "রেট করুন", noTitle: "এখন নয়")
            ), onYes: {
                RateAppManager.openWriteReviewPage()
            }
        )
    }

    func openSocial(_ type: SocialLinkType) {
        if let appURL = type.appURL, UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:])
        } else {
            UIApplication.shared.open(type.webURL, options: [:])
        }
    }

    func signOut(from navigationController: UINavigationController?) {
        Alert.show(
            AlertConfig(
                title: "আপনি কি নিশ্চিত?",
                icon: .image(.signoutCircle),
                buttons: .yesNo()
            ), onYes: { [weak navigationController] in
                navigationController?.logoutAndGoToSignIn()
            }
        )
    }
}
