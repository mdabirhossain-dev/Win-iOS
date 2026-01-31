//
//
//  TotalScoreEntity.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class TotalScorePresenter: TotalScorePresenterProtocol {

    weak var view: TotalScoreViewProtocol?
    var interactor: TotalScoreInteractorInputProtocol?
    var router: TotalScoreRouterProtocol?

    private var response: CampaignWiseScores?
    private var totalScore: Int?

    func setInitial(totalScore: Int) {
        self.totalScore = totalScore
    }

    func viewDidLoad() {
        view?.setLoading(true)
        interactor?.getScoreDetails()
    }

    func numberOfSections() -> Int { 2 }

    func numberOfRows(in section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return response?.count ?? 0
        default: return 0
        }
    }

    func configureCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TotalPointAndScoreTableViewCell.className,
                for: indexPath
            ) as! TotalPointAndScoreTableViewCell

            cell.configure(type: .totalScore(score: totalScore ?? 0))
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TotalPointAndScoreBreakdownTableViewCell.className,
                for: indexPath
            ) as! TotalPointAndScoreBreakdownTableViewCell

            let breakdown = response ?? []
            if indexPath.row < breakdown.count {
                let item = breakdown[indexPath.row]
                cell.configure(type: .totalScore(score: item.score ?? 0),
                               walletTitle: item.campaignTitle ?? "")
            }
            return cell

        default:
            return UITableViewCell()
        }
    }

    // MARK: - Error mapping (non-server)
    private func userFriendlyBanglaMessage(for error: Error) -> String {
        // ✅ If server already gave message -> show that (as you asked)
        if let ns = error as NSError?, ns.domain == "TotalScoreServer" {
            return ns.localizedDescription
        }

        // Network / timeout / offline fallbacks (Bangla)
        if let apiErr = error as? APIError {
            switch apiErr {
            case .transport(let e):
                let code = (e as NSError).code
                if code == URLError.notConnectedToInternet.rawValue { return "ইন্টারনেট সংযোগ নেই" }
                if code == URLError.timedOut.rawValue { return "সময় শেষ হয়ে গেছে, আবার চেষ্টা করুন" }
                return "নেটওয়ার্ক সমস্যা হয়েছে, আবার চেষ্টা করুন"
            case .invalidResponse:
                return "সার্ভার থেকে সঠিক রেসপন্স পাওয়া যায়নি"
            case .emptyData:
                return "সার্ভার থেকে ডেটা পাওয়া যায়নি"
            case .decoding:
                return "ডেটা পড়তে সমস্যা হয়েছে"
            case .encoding:
                return "ডেটা পাঠাতে সমস্যা হয়েছে"
            case .badURL:
                return "ভুল রিকোয়েস্ট"
            case .server:
                // This normally shouldn't hit if we handle status in interactor,
                return "সার্ভার ত্রুটি হয়েছে"
            }
        }

        // URLError fallback
        if let urlErr = error as? URLError {
            switch urlErr.code {
            case .notConnectedToInternet: return "ইন্টারনেট সংযোগ নেই"
            case .timedOut: return "সময় শেষ হয়ে গেছে, আবার চেষ্টা করুন"
            default: return "নেটওয়ার্ক সমস্যা হয়েছে, আবার চেষ্টা করুন"
            }
        }

        // Generic fallback
        return "কিছু একটা সমস্যা হয়েছে, আবার চেষ্টা করুন"
    }
}

// MARK: - Interactor Output
extension TotalScorePresenter: TotalScoreInteractorOutputProtocol {

    func didReceiveScoreDetails(_ response: CampaignWiseScores) {
        self.response = response
        view?.setLoading(false)
        view?.reload()
    }

    func didFail(_ error: Error) {
        view?.setLoading(false)
        view?.showToast(message: userFriendlyBanglaMessage(for: error), isError: true)
    }
}

//final class TotalScorePresenter: TotalScorePresenterProtocol {
//    weak var view: TotalScoreViewProtocol?
//    var interactor: TotalScoreInteractorInputProtocol?
//    var router: TotalScoreRouterProtocol?
//
//    // State
//    private var response: CampaignWiseScores?
//    private var totalScore: Int?
//
//    func setInitial(totalScore: Int) {
//        self.totalScore = totalScore
//    }
//
//    func viewDidLoad() {
//        view?.setLoading(true)
//        interactor?.getScoreDetails()
//    }
//
//    func numberOfSections() -> Int {
//        // For now, two demo sections like the previous VC: breakdown and total
//        return 2
//    }
//
//    func numberOfRows(in section: Int) -> Int {
//        switch section {
//        case 0:
//            return 1
//        case 1:
//            return response?.count ?? 0
//        default:
//            return 0
//        }
//    }
//
//    func configureCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0:
//            let cell = tableView.dequeueReusableCell(withIdentifier: TotalPointAndScoreTableViewCell.className, for: indexPath) as! TotalPointAndScoreTableViewCell
//            let score = totalScore ?? 0
//            cell.configure(type: .totalScore(score: score))
//            return cell
//        case 1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: TotalPointAndScoreBreakdownTableViewCell.className, for: indexPath) as! TotalPointAndScoreBreakdownTableViewCell
//            let breakdown = response ?? []
//            if indexPath.row < breakdown.count {
//                let item = breakdown[indexPath.row]
//                cell.configure(type: .totalScore(score: item.score ?? 0), walletTitle: item.campaignTitle ?? "")
//            }
//            return cell
//        default:
//            return UITableViewCell()
//        }
//    }
//}
//
//extension TotalScorePresenter: TotalScoreInteractorOutputProtocol {
//    func didReceiveScoreDetails(_ response: CampaignWiseScores) {
//        self.response = response
//        view?.setLoading(false)
//        view?.reload()
//    }
//
//    func didFail(_ error: Error) {
//        view?.setLoading(false)
//        view?.showError(error.localizedDescription)
//    }
//}

