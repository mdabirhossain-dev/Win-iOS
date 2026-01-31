//
//
//  HelpAndSupportRouter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class HelpAndSupportRouter: HelpAndSupportRouterProtocol {
    weak var viewController: UIViewController?

    static func createModule() -> UIViewController {
        let vc = HelpAndSupportViewController()

        let networkClient: NetworkClientProtocol = NetworkClient()
        let interactor = HelpAndSupportInteractor(networkClient: networkClient)
        let router = HelpAndSupportRouter()

        let presenter = HelpAndSupportPresenter(
            view: vc,
            interactor: interactor,
            router: router
        )

        vc.presenter = presenter
        interactor.output = presenter
        router.viewController = vc

        return vc
    }

    func dismiss(from view: HelpAndSupportViewProtocol?) {
        viewController?.navigationController?.popViewController(animated: true)
    }
}

//final class HelpAndSupportRouter: HelpAndSupportRouterProtocol {
//    weak var viewController: UIViewController?
//    
//    static func createModule() -> UIViewController {
//        let vc = HelpAndSupportViewController()
//        let networkClient = NetworkClient()
//        let interactor = HelpAndSupportInteractor(networkClient: networkClient)
//        let router = HelpAndSupportRouter()
//        
//        let presenter = HelpAndSupportPresenter(
//            view: vc,
//            interactor: interactor,
//            router: router
//        )
//        
//        vc.presenter = presenter
//        interactor.output = presenter
//        router.viewController = vc
//        
//        return vc
//    }
//    
//    func dismiss(from view: HelpAndSupportViewProtocol?) {
//        viewController?.navigationController?.popViewController(animated: true)
//    }
//}
