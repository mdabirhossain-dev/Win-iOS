//
//
//  RedeemScoreRouter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import UIKit

final class RedeemScoreRouter: RedeemScoreRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = RedeemScoreViewController()

        let presenter = RedeemScorePresenter()
        let interactor = RedeemScoreInteractor()
        let router = RedeemScoreRouter()

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter
        router.viewController = view

        return view
    }
}