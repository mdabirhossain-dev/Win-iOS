//
//
//  ScoreboardRouter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class ScoreboardRouter: ScoreboardRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = ScoreboardViewController()

        let presenter = ScoreboardPresenter()
        let interactor = ScoreboardInteractor()
        let router = ScoreboardRouter()

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter
        router.viewController = view

        return view
    }

    func goBackToHomeTab() {
        guard let tabBar = viewController?.tabBarController as? TabbarContoller else {
            viewController?.navigationController?.popViewController(animated: true)
            return
        }
        // MARK: - Home Tabbar Index is 1
        tabBar.chanageTabbar(for: 1)
    }
}
