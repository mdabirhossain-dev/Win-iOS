//
//
//  NewPasswordRouter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import UIKit

final class NewPasswordRouter: NewPasswordRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule(msisdn: String, otp: String) -> UIViewController {
        let view = NewPasswordViewController(msisdn: msisdn, otp: otp)

        let presenter = NewPasswordPresenter(msisdn: msisdn, otp: otp)
        let interactor = NewPasswordInteractor()
        let router = NewPasswordRouter()

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

    func goToRootAfterSuccess() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }
}