//
//
//  StorePresenter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 25/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import UIKit

final class StorePresenter: StorePresenterProtocol {

    weak var view: StoreViewProtocol?
    var interactor: StoreInteractorProtocol?
    var router: StoreRouterProtocol?

    private enum PlanSection {
        case subscription
        case ondemand

        var title: String {
            switch self {
            case .subscription: return "সাবস্ক্রিপশন"
            case .ondemand: return "ওয়ান টাইম"
            }
        }
    }

    private var wallets: PaymentWallets = []
    private var subscriptionPlans: [PurchasePlan] = []
    private var ondemandPlans: [PurchasePlan] = []
    private var selectedIndex: Int = 0

    private var visiblePlanSections: [PlanSection] = []

    private var pendingClientCorrelator: String?
    private var pendingWalletID: Int?

    func viewDidLoad() {
        view?.setLoading(true)
        interactor?.fetchWallets()
    }

    func didTapClose() {
        router?.goBack()
    }

    func didSelectWallet(at index: Int) {
        guard index >= 0, index < wallets.count else { return }
        selectedIndex = index
        view?.reloadWallets()

        guard let walletID = wallets[index].walletID else { return }
        view?.setLoading(true)
        interactor?.fetchPlans(walletID: walletID)
    }

    func didTapPlan(at indexPath: IndexPath) {
        guard selectedIndex < wallets.count else { return }
        guard let walletID = wallets[selectedIndex].walletID else { return }
        guard let plan = plan(at: indexPath), let planID = plan.planID else { return }

        view?.setLoading(true)
        interactor?.startPurchase(walletID: walletID, planID: planID)
    }

    // MARK: - Wallet DS

    func walletCount() -> Int { wallets.count }

    func wallet(at index: Int) -> PaymentWallet? {
        guard index >= 0, index < wallets.count else { return nil }
        return wallets[index]
    }

    func selectedWalletIndex() -> Int { selectedIndex }

    // MARK: - Plans DS

    func planSectionsCount() -> Int { visiblePlanSections.count }

    func planSectionTitle(at section: Int) -> String {
        guard section >= 0, section < visiblePlanSections.count else { return "" }
        return visiblePlanSections[section].title
    }

    func plansCount(in section: Int) -> Int {
        guard section >= 0, section < visiblePlanSections.count else { return 0 }
        switch visiblePlanSections[section] {
        case .subscription: return subscriptionPlans.count
        case .ondemand: return ondemandPlans.count
        }
    }

    func plan(at indexPath: IndexPath) -> PurchasePlan? {
        guard indexPath.section >= 0, indexPath.section < visiblePlanSections.count else { return nil }
        switch visiblePlanSections[indexPath.section] {
        case .subscription:
            guard indexPath.item >= 0, indexPath.item < subscriptionPlans.count else { return nil }
            return subscriptionPlans[indexPath.item]
        case .ondemand:
            guard indexPath.item >= 0, indexPath.item < ondemandPlans.count else { return nil }
            return ondemandPlans[indexPath.item]
        }
    }

    private func rebuildSections() {
        var sections: [PlanSection] = []
        if !subscriptionPlans.isEmpty { sections.append(.subscription) }
        if !ondemandPlans.isEmpty { sections.append(.ondemand) }
        visiblePlanSections = sections
    }
}

// MARK: - Interactor Output
extension StorePresenter: StoreInteractorOutput {

    func walletsFetched(_ wallets: PaymentWallets) {
        view?.setLoading(false)

        self.wallets = wallets
        self.selectedIndex = 0
        view?.reloadWallets()

        guard let walletID = wallets.first?.walletID else {
            view?.showToast(message: "কোনো ওয়ালেট পাওয়া যায়নি", isError: true)
            return
        }

        view?.setLoading(true)
        interactor?.fetchPlans(walletID: walletID)
    }

    func walletsFailed(_ message: String) {
        view?.setLoading(false)
        view?.showToast(message: message, isError: true)
        self.wallets = []
        view?.reloadWallets()
    }

    func plansFetched(_ data: PurchasePlansData) {
        view?.setLoading(false)

        subscriptionPlans = data.subscriptionPlans ?? []
        ondemandPlans = data.ondemandPlans ?? []

        rebuildSections()
        view?.reloadPlans()
    }

    func plansFailed(_ message: String) {
        view?.setLoading(false)
        view?.showToast(message: message, isError: true)

        subscriptionPlans = []
        ondemandPlans = []
        rebuildSections()
        view?.reloadPlans()
    }

    func requireOTP(clientCorrelator: String) {
        view?.setLoading(false)

        guard selectedIndex < wallets.count else { return }
        let wallet = wallets[selectedIndex]
        guard let walletID = wallet.walletID else { return }

        pendingClientCorrelator = clientCorrelator
        pendingWalletID = walletID

        router?.presentOTP(walletImageURL: wallet.walletImage) { [weak self] otp in
            guard let self else { return }
            guard let correlator = self.pendingClientCorrelator,
                  let wid = self.pendingWalletID else { return }

            self.view?.setLoading(true)
            self.interactor?.completeOTPFlow(walletID: wid, otp: otp, clientCorrelator: correlator)
        }
    }

    func openWeb(urlString: String) {
        view?.setLoading(false)

        router?.presentPaymentWeb(urlString: urlString) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success:
                Toast.show("অভিনন্দন! আপনার পেমেন্ট সম্পন্ন হয়েছে।", style: .success)
                self.router?.goBack()
            case .failure:
                Toast.show("দুঃখিত! পেমেন্ট ব্যর্থ হয়েছে।", style: .error)
            }
        }
    }

    func otpPaymentResultSucceeded() {
        view?.setLoading(false)
        Toast.show("অভিনন্দন! আপনার পেমেন্ট সম্পন্ন হয়েছে।", style: .success)
        router?.goBack()
    }

    func otpPaymentResultFailed(_ message: String) {
        view?.setLoading(false)
        view?.showToast(message: message, isError: true)
    }
}