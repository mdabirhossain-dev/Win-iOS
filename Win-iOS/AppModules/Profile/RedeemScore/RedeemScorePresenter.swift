//
//
//  RedeemScorePresenter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import UIKit

enum RedeemScoreSection {
    case totalScore(Int)
    case giftVouchers([Cashback])
    case cashback([Cashback])

    var title: String {
        switch self {
        case .totalScore: return "Total Score"
        case .giftVouchers: return "Gift Vouchers"
        case .cashback: return "Cashback"
        }
    }
}

final class RedeemScorePresenter: RedeemScorePresenterProtocol {

    weak var view: RedeemScoreViewProtocol?
    var interactor: RedeemScoreInteractorInputProtocol?
    var router: RedeemScoreRouterProtocol?

    private(set) var couponList: RedeemScore?
    private(set) var sections: [RedeemScoreSection] = []

    func viewDidLoad() {
        view?.setLoading(true)
        interactor?.fetchRedeemScore()
    }

    func numberOfSections() -> Int { sections.count }

    func numberOfRows(in section: Int) -> Int { 1 } // each section is a single row container

    func sectionTitle(at section: Int) -> String {
        guard section < sections.count else { return "" }
        return sections[section].title
    }

    func section(at index: Int) -> RedeemScoreSection? {
        guard index < sections.count else { return nil }
        return sections[index]
    }

    private func buildSections(from data: RedeemScore) {
        var temp: [RedeemScoreSection] = []

        if let total = data.totalScore {
            temp.append(.totalScore(total))
        }

        if let vouchers = data.giftVouchers, !vouchers.isEmpty {
            temp.append(.giftVouchers(vouchers))
        }

        if let cashbacks = data.cashback, !cashbacks.isEmpty {
            temp.append(.cashback(cashbacks))
        }

        self.sections = temp
    }
}

// MARK: - Interactor Output
extension RedeemScorePresenter: RedeemScoreInteractorOutput {

    func redeemScoreFetched(_ data: RedeemScore) {
        couponList = data
        buildSections(from: data)

        view?.setLoading(false)
        view?.reload()
    }

    func redeemScoreFailed(_ message: String) {
        couponList = nil
        sections = []

        view?.setLoading(false)
        view?.showToast(message: message, isError: true)
        view?.reload()
    }
}
