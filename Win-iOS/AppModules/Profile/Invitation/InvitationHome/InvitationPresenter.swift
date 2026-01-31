//
//
//  InvitationPresenter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import UIKit

final class InvitationPresenter: InvitationPresenterProtocol {

    weak var view: InvitationViewProtocol?
    var interactor: InvitationInteractorInputProtocol?
    var router: InvitationRouterProtocol?

    private var invitationResponse: InvitationResponse?

    func viewDidLoad() {
        view?.setInvitationUIVisible(false)
        view?.setLoading(true)
        interactor?.fetchInvitationInfo()
    }

    func didTapHistory(navigationController: UINavigationController?) {
        router?.navigateToHistory(from: navigationController)
    }

    func invitationCodeText() -> String {
        (invitationResponse?.invitationCode ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func shareMessage() -> String? {
        let code = invitationCodeText()
        guard !code.isEmpty else { return nil }

        return "আমার কোড ব্যবহার করে Win এ সাইন আপ করুন। কুইজ খেলে জিতে নিতে পারেন ক্যাশব্যাক। Code: \(code) Link: \(APIConstants.winWebHomeURL)"
    }
}

// MARK: - Interactor Output
extension InvitationPresenter: InvitationInteractorOutput {

    func invitationInfoFetched(_ response: InvitationResponse) {
        invitationResponse = response

        view?.setLoading(false)

        let pointsText = "\(response.point?.toBanglaNumberWithSuffix() ?? "০") পয়েন্ট"
        let codeText = "  \(invitationCodeText())"

        let hasCode = !invitationCodeText().isEmpty
        view?.setInvitationUIVisible(hasCode)
        view?.setInvitation(pointsText: pointsText, codeText: codeText)
    }

    func invitationInfoFailed(_ message: String) {
        view?.setLoading(false)
        view?.setInvitationUIVisible(false)
        view?.showToast(message: message, isError: true)
    }
}