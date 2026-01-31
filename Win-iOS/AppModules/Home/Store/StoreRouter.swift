//
//
//  StoreRouter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 25/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import UIKit

final class StoreRouter: StoreRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let view = StoreViewController()

        let presenter = StorePresenter()
        let interactor = StoreInteractor()
        let router = StoreRouter()

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

    func presentOTP(walletImageURL: String?, onSubmit: @escaping (String) -> Void) {
        let popup = OTPConfirmationViewController(imageURLString: walletImageURL)
        popup.onSubmit = { otp in onSubmit(otp) }
        popup.onCancel = { }
        viewController?.present(popup, animated: true)
    }

    func presentPaymentWeb(urlString: String, onResult: @escaping (Result<Void, Error>) -> Void) {
        let vc = PaymentWebViewController(urlString: urlString)

        vc.onResult = { result in
            switch result {
            case .success:
                onResult(.success(()))
            case .failure:
                onResult(.failure(NSError(domain: "PaymentWeb", code: -1, userInfo: [NSLocalizedDescriptionKey: "Payment failed"])))
            }
        }

        let nav = UINavigationController(rootViewController: vc)
        viewController?.present(nav, animated: true)
    }
}