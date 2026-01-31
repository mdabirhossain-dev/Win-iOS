//
//
//  HomeRouter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 25/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import UIKit

final class HomeRouter: HomeRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = HomeViewController()

        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        let router = HomeRouter()

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter
        router.viewController = view

        return view
    }

    func goToStore() {
        viewController?.navigationController?.pushViewController(.store)
    }

    func switchToScoreboardTab() {
        guard let tabBar = viewController?.tabBarController as? TabbarContoller else { return }
        tabBar.chanageTabbar(for: 0)
    }

    func goToOnlineGame(_ gameID: Int) {
        viewController?.navigationController?.pushViewController(.onlineGames(gameID))
    }

    func goToSignUp() {
        viewController?.navigationController?.pushViewController(.signUp)
    }

    func goToUpdateProfile() {
        viewController?.navigationController?.pushViewController(
            .updateProfile(UpdateProfileRequest(fullName: "FULL name", gender: "", userAvatarId: "DD"), avatarUrl: "")
        )
    }

    func goToInvitation() {
        viewController?.navigationController?.pushViewController(.invitation)
    }

    func goToGiftPoint() {
        viewController?.navigationController?.pushViewController(.giftPoint())
    }

    func goToRequestPoint() {
        viewController?.navigationController?.pushViewController(.requestPoint())
    }
}