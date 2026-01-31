//
//
//  GiftPointPresenter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 25/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import Foundation

final class GiftPointPresenter: GiftPointPresenterProtocol {

    weak var view: GiftPointViewProtocol?
    var interactor: GiftPointInteractorProtocol?
    var router: GiftPointRouterProtocol?

    private let initialUserSummary: UserSummaryResponse?

    private var pendingWork = 0 {
        didSet { view?.setLoading(pendingWork > 0) }
    }

    private var pendingTransfer: (msisdn: String, amount: Int, walletID: Int, walletTitle: String?)?

    init(initialUserSummary: UserSummaryResponse?) {
        self.initialUserSummary = initialUserSummary
    }

    func viewDidLoad() {
        if let summary = initialUserSummary {
            view?.showUserSummary(summary)
            return
        }
        pendingWork += 1
        interactor?.fetchUserSummary()
    }

    func didTapGift(receiverMSISDN: String?, pointAmountText: String?, selectedWallet: PointBreakdown?) {
        let msisdn = (receiverMSISDN ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let amountText = (pointAmountText ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !msisdn.isEmpty else {
            view?.showToast(message: "পয়েন্ট গ্রাহকের ফোন নম্বর দিন", isError: true)
            return
        }

        guard msisdn.count >= 11 else {
            view?.showToast(message: "সঠিক ফোন নম্বর দিন", isError: true)
            return
        }

        guard let wallet = selectedWallet, let walletID = wallet.walletId else {
            view?.showToast(message: "পয়েন্টের ধরণ সিলেক্ট করুন", isError: true)
            return
        }

        guard let amount = Int(amountText), amount > 0 else {
            view?.showToast(message: "পয়েন্টের পরিমান দিন", isError: true)
            return
        }

        pendingTransfer = (msisdn: msisdn, amount: amount, walletID: walletID, walletTitle: wallet.walletTitle)

        pendingWork += 1
        interactor?.fetchReceiverInfo(msisdn: msisdn)
    }

    func didConfirmTransfer(receiverMSISDN: String, pointAmount: Int, walletID: Int) {
        pendingWork += 1
        interactor?.transferPoints(
            PointTransferRequest(
                receiverMSISDN: receiverMSISDN,
                walletID: walletID,
                pointAmount: pointAmount
            )
        )
    }

    func didTapBack() {
        router?.goBack()
    }
}

extension GiftPointPresenter: GiftPointInteractorOutput {

    func userSummaryFetched(_ summary: UserSummaryResponse) {
        pendingWork = max(0, pendingWork - 1)
        view?.showUserSummary(summary)
    }

    func userSummaryFailed(_ message: String) {
        pendingWork = max(0, pendingWork - 1)
        view?.showToast(message: message, isError: true)
    }

    func receiverInfoFetched(_ user: UserInfo) {
        pendingWork = max(0, pendingWork - 1)

        guard let pending = pendingTransfer else {
            view?.showToast(message: "অনুগ্রহ করে আবার চেষ্টা করুন", isError: true)
            return
        }

        let isRegistered = (user.msisdn ?? "").isNotEmpty
        guard isRegistered else {
            view?.showNotRegisteredAlert()
            return
        }

        let fullName = user.fullName ?? ""
        let msisdn = user.msisdn ?? pending.msisdn
        view?.showConfirmTransfer(
            fullName: fullName,
            msisdn: msisdn,
            pointAmount: String(pending.amount),
            walletTitle: pending.walletTitle
        )
    }

    func receiverInfoFailed(_ message: String) {
        pendingWork = max(0, pendingWork - 1)
        view?.showToast(message: message, isError: true)
    }

    func pointTransferSucceeded() {
        pendingWork = max(0, pendingWork - 1)
        view?.showTransferSuccess()
    }

    func pointTransferFailed(_ message: String) {
        pendingWork = max(0, pendingWork - 1)
        view?.showToast(message: message, isError: true)
    }
}