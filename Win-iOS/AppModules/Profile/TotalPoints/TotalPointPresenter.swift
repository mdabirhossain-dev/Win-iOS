//
//
//  TotalPointPresenter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//

import UIKit

final class TotalPointPresenter: TotalPointPresenterProtocol {

    weak var view: TotalPointViewProtocol?
    var interactor: TotalPointInteractorInputProtocol?
    var router: TotalPointRouterProtocol?

    private var response: TotalPointResponse?
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
        case 1: return response?.pointsBreakdown?.count ?? 0
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

            let score = totalScore ?? 0
            cell.configure(type: .totalPoint(score: score))
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TotalPointAndScoreBreakdownTableViewCell.className,
                for: indexPath
            ) as! TotalPointAndScoreBreakdownTableViewCell

            if let list = response?.pointsBreakdown, indexPath.row < list.count {
                let item = list[indexPath.row]
                cell.configure(
                    type: .totalPoint(score: item.score ?? 0),
                    walletTitle: item.walletTitle ?? ""
                )
            }
            return cell

        default:
            return UITableViewCell()
        }
    }
}

// MARK: - Interactor Output
extension TotalPointPresenter: TotalPointInteractorOutputProtocol {

    func didReceivePointDetails(_ response: TotalPointResponse) {
        self.response = response
        view?.setLoading(false)
        view?.reload()
    }

    func didFail(_ error: Error) {
        view?.setLoading(false)
        view?.showToast(message: error.localizedDescription, isError: true)
    }
}

//final class TotalPointPresenter: TotalPointPresenterProtocol {
//    weak var view: TotalPointViewProtocol?
//    var interactor: TotalPointInteractorInputProtocol?
//    var router: TotalPointRouterProtocol?
//    
//    // State
//    private var response: TotalPointResponse?
//    private var totalScore: Int?
//    
//    // MARK: - Lifecycle
//    func setInitial(totalScore: Int) {
//        self.totalScore = totalScore
//    }
//    
//    func viewDidLoad() {
//        view?.setLoading(true)
//        interactor?.getScoreDetails()
//    }
//    
//    // MARK: - Data source
//    func numberOfSections() -> Int {
//        // 0 = total, 1 = breakdown
//        return 2
//    }
//    
//    func numberOfRows(in section: Int) -> Int {
//        switch section {
//        case 0:
//            return 1
//        case 1:
//            return response?.pointsBreakdown?.count ?? 0
//        default:
//            return 0
//        }
//    }
//    
//    func configureCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
//        switch indexPath.section {
//        case 0:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: TotalPointAndScoreTableViewCell.className,
//                for: indexPath
//            ) as! TotalPointAndScoreTableViewCell
//            
//            let score = totalScore ?? 0
//            cell.configure(type: .totalPoint(score: score))
//            return cell
//            
//        case 1:
//            let cell = tableView.dequeueReusableCell(
//                withIdentifier: TotalPointAndScoreBreakdownTableViewCell.className,
//                for: indexPath
//            ) as! TotalPointAndScoreBreakdownTableViewCell
//            
//            if let response = response?.pointsBreakdown, indexPath.row < response.count {
//                let item = response[indexPath.row]
//                cell.configure(
//                    type: .totalPoint(score: item.score ?? 0),
//                    walletTitle: item.walletTitle ?? ""
//                )
//            }
//            return cell
//            
//        default:
//            return UITableViewCell()
//        }
//    }
//}
//
//// MARK: - Interactor Output
//extension TotalPointPresenter: TotalPointInteractorOutputProtocol {
//    func didReceivePointDetails(_ response: TotalPointResponse) {
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
