//
//
//  GiftPointProtocols.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 25/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

protocol GiftPointViewProtocol: AnyObject {
    func setLoading(_ isLoading: Bool)
    func showToast(message: String, isError: Bool)

    func showUserSummary(_ summary: UserSummaryResponse)

    func showNotRegisteredAlert()
    func showConfirmTransfer(fullName: String, msisdn: String, pointAmount: String, walletTitle: String?)
    func showTransferSuccess()
}

protocol GiftPointPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapGift(receiverMSISDN: String?, pointAmountText: String?, selectedWallet: PointBreakdown?)
    func didConfirmTransfer(receiverMSISDN: String, pointAmount: Int, walletID: Int)
    func didTapBack()
}

protocol GiftPointInteractorProtocol: AnyObject {
    func fetchUserSummary()
    func fetchReceiverInfo(msisdn: String)
    func transferPoints(_ request: PointTransferRequest)
}

protocol GiftPointInteractorOutput: AnyObject {
    func userSummaryFetched(_ summary: UserSummaryResponse)
    func userSummaryFailed(_ message: String)

    func receiverInfoFetched(_ user: UserInfo)
    func receiverInfoFailed(_ message: String)

    func pointTransferSucceeded()
    func pointTransferFailed(_ message: String)
}

protocol GiftPointRouterProtocol: AnyObject {
    static func createModule(userSummary: UserSummaryResponse?) -> UIViewController
    func goBack()
}
