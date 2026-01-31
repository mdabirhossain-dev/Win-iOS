//
//
//  InvitationHistoryPresenter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 30/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

final class InvitationHistoryPresenter: InvitationHistoryPresenterProtocol {

    weak var view: InvitationHistoryViewProtocol?
    var interactor: InvitationHistoryInteractorInput?
    var router: InvitationHistoryRouterProtocol?

    private var invitationList: InvitationList = []

    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchInvitationHistory()
    }

    func didTapBack() {
        router?.goBack()
    }

    func numberOfItems() -> Int {
        invitationList.count
    }

    func item(at index: Int) -> InvitationResponse? {
        guard invitationList.indices.contains(index) else { return nil }
        return invitationList[index]
    }
}

// MARK: - Interactor Output
extension InvitationHistoryPresenter: InvitationHistoryInteractorOutput {

    func invitationHistoryFetched(_ list: InvitationList?) {
        view?.hideLoading()
        self.invitationList = list ?? []
        view?.reloadTableView()
    }

    func invitationHistoryFailed(_ message: String) {
        view?.hideLoading()
        view?.showError(message)
        self.invitationList = []
        view?.reloadTableView()
    }
}
