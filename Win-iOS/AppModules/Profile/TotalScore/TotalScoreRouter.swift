//
//
//  TotalScoreRouter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class TotalScoreRouter: TotalScoreRouterProtocol {
    static func createModule(_ totalScore: Int) -> UIViewController {
        let view = TotalScoreViewController(totalScore)
        let presenter = TotalScorePresenter()
        let interactor = TotalScoreInteractor()
        let router = TotalScoreRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.output = presenter

        return view
    }

    func dismiss(from view: TotalScoreViewProtocol?) {
        guard let viewController = view as? UIViewController else { return }
        if let navigationController = viewController.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            viewController.dismiss(animated: true)
        }
    }
}
