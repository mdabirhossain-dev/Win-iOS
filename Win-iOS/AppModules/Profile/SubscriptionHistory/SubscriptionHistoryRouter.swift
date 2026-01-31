//
//
//  SubscriptionHistoryRouter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - Router
class SubscriptionHistoryRouter: SubscriptionHistoryRouterProtocol {
    
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let view = SubscriptionHistoryViewController()
        let presenter = SubscriptionHistoryPresenter()
        let interactor = SubscriptionHistoryInteractor()
        let router = SubscriptionHistoryRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func dismissView() {
        viewController?.navigationController?.popViewController(animated: true)
    }
}
