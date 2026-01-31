//
//
//  SubscriptionHistoryProtocol.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - Protocol Contracts
protocol SubscriptionHistoryViewProtocol: AnyObject {
    var presenter: SubscriptionHistoryPresenterProtocol? { get set }

    func showLoading()
    func hideLoading()
    func reloadTableView()
    
    func showToast(message: String, isError: Bool)
}

protocol SubscriptionHistoryPresenterProtocol: AnyObject {
    var view: SubscriptionHistoryViewProtocol? { get set }
    var interactor: SubscriptionHistoryInteractorInputProtocol? { get set }
    var router: SubscriptionHistoryRouterProtocol? { get set }
    var historys: [SubscriptionHistory]? { get set }
    
    func getSubscriptionHistory()
}

protocol SubscriptionHistoryInteractorInputProtocol: AnyObject {
    var presenter: SubscriptionHistoryInteractorOutputProtocol? { get set }
    
    func getSubscriptionHistory()
}

protocol SubscriptionHistoryInteractorOutputProtocol: AnyObject {
    func didReceivedSubscriptionHistory(history: [SubscriptionHistory])
    func didReceivedErrorWhileFetchingSubscriptionHistory(error: Error)
}

protocol SubscriptionHistoryRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func dismissView()
}
