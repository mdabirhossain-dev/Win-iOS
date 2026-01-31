//
//
//  SubscriptionHistoryPresenter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

final class SubscriptionHistoryPresenter: SubscriptionHistoryPresenterProtocol {

    weak var view: SubscriptionHistoryViewProtocol?
    var interactor: SubscriptionHistoryInteractorInputProtocol?
    var router: SubscriptionHistoryRouterProtocol?

    var historys: [SubscriptionHistory]?

    func getSubscriptionHistory() {
        view?.showLoading()
        interactor?.getSubscriptionHistory()
    }
}

extension SubscriptionHistoryPresenter: SubscriptionHistoryInteractorOutputProtocol {

    func didReceivedErrorWhileFetchingSubscriptionHistory(error: Error) {
        view?.hideLoading()
        view?.showToast(message: error.localizedDescription, isError: true)
    }

    func didReceivedSubscriptionHistory(history: [SubscriptionHistory]) {
        historys = history
        view?.reloadTableView()
        view?.hideLoading()

        // Optional: if you want to tell user there’s nothing
        // if history.isEmpty {
        //     view?.showToast(message: "কোন সাবস্ক্রিপশন হিস্ট্রি পাওয়া যায়নি", isError: false)
        // }
    }
}

//class SubscriptionHistoryPresenter: SubscriptionHistoryPresenterProtocol {
//    weak var view: SubscriptionHistoryViewProtocol?
//    var interactor: SubscriptionHistoryInteractorInputProtocol?
//    var router: SubscriptionHistoryRouterProtocol?
//    
//    var historys: [SubscriptionHistory]?
//    
//    func getSubscriptionHistory() {
//        view?.showLoading()
//        interactor?.getSubscriptionHistory()
//    }
//}
//
//
//extension SubscriptionHistoryPresenter: SubscriptionHistoryInteractorOutputProtocol {
//    func didReceivedErrorWhileFetchingSubscriptionHistory(error: any Error) {
//        Task { @MainActor in
//            view?.hideLoading()
//        }
//    }
//    
//    func didReceivedSubscriptionHistory(history: [SubscriptionHistory]) {
//        Task { @MainActor in
//            historys = history
//            view?.reloadTableView()
//            view?.hideLoading()
//        }
//    }
//}
