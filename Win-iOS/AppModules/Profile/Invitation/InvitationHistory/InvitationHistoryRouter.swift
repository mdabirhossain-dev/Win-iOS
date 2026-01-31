//
//
//  InvitationHistoryRouter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 30/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class InvitationHistoryRouter: InvitationHistoryRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = InvitationHistoryViewController()

        let presenter = InvitationHistoryPresenter()
        let interactor = InvitationHistoryInteractor()
        let router = InvitationHistoryRouter()

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter
        router.viewController = view

        return view
    }

    func goBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
