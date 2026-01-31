//
//
//  StoreProtocols.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 25/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - View
protocol StoreViewProtocol: AnyObject {
    func setLoading(_ isLoading: Bool)
    func reloadWallets()
    func reloadPlans()
    func showToast(message: String, isError: Bool)
}

// MARK: - Presenter
protocol StorePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapClose()
    func didSelectWallet(at index: Int)
    func didTapPlan(at indexPath: IndexPath)

    // Wallets
    func walletCount() -> Int
    func wallet(at index: Int) -> PaymentWallet?
    func selectedWalletIndex() -> Int

    // Plans sections
    func planSectionsCount() -> Int
    func planSectionTitle(at section: Int) -> String
    func plansCount(in section: Int) -> Int
    func plan(at indexPath: IndexPath) -> PurchasePlan?
}

// MARK: - Interactor
protocol StoreInteractorProtocol: AnyObject {
    func fetchWallets()
    func fetchPlans(walletID: Int)
    func startPurchase(walletID: Int, planID: Int)
    func completeOTPFlow(walletID: Int, otp: String, clientCorrelator: String)
}

protocol StoreInteractorOutput: AnyObject {
    func walletsFetched(_ wallets: PaymentWallets)
    func walletsFailed(_ message: String)

    func plansFetched(_ data: PurchasePlansData)
    func plansFailed(_ message: String)

    func requireOTP(clientCorrelator: String)
    func openWeb(urlString: String)

    func otpPaymentResultSucceeded()
    func otpPaymentResultFailed(_ message: String)
}

// MARK: - Router
protocol StoreRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func goBack()

    func presentOTP(
        walletImageURL: String?,
        onSubmit: @escaping (String) -> Void
    )

    func presentPaymentWeb(
        urlString: String,
        onResult: @escaping (Result<Void, Error>) -> Void
    )
}
