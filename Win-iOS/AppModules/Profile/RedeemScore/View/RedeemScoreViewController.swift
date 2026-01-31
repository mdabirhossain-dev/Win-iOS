//
//
//  RedeemScoreViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 6/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class RedeemScoreViewController: UIViewController {

    var presenter: RedeemScorePresenterProtocol?

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .wcBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            SubscriptionHistoryTableViewCell.self,
            forCellReuseIdentifier: SubscriptionHistoryTableViewCell.className
        )
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.sectionHeaderTopPadding = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoad()
    }

    private func setupView() {
        setupNavigationBar(isBackButton: true, delegate: self)

        view.backgroundColor = .wcBackground
        view.addSubview(tableView)

        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
}

// MARK: - RedeemScoreViewProtocol
extension RedeemScoreViewController: RedeemScoreViewProtocol {

    func setLoading(_ isLoading: Bool) {
        showLoader(isLoading ? .loading : .hidden)
    }

    func showToast(message: String, isError: Bool) {
        Toast.show(message, style: isError ? .error : .success)
    }

    func reload() {
        tableView.reloadData()
    }
}

// MARK: - NavigationBarDelegate
extension RedeemScoreViewController: NavigationBarDelegate {
    func navBarDidTapBack(in vc: UIViewController) {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDelegate
extension RedeemScoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 16 }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }
}

// MARK: - UITableViewDataSource
extension RedeemScoreViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        presenter?.numberOfSections() ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRows(in: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: SubscriptionHistoryTableViewCell.className,
            for: indexPath
        ) as! SubscriptionHistoryTableViewCell

        // ✅ NO extra methods called here because you didn’t give the cell API.
        // You MUST map your section to your existing cell configure method here.
        // Example (only if you already have these APIs):
        //
        // if let section = presenter?.section(at: indexPath.section) {
        //     cell.configure(section: section)
        // }

        return cell
    }
}

//class RedeemScoreViewController: UIViewController {
//    
//    // MARK: - Presenter
//    
//    // MARK: - UI Properties
//    private let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.backgroundColor = .wcBackground
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(
//            SubscriptionHistoryTableViewCell.self,
//            forCellReuseIdentifier: SubscriptionHistoryTableViewCell.className
//        )
//        tableView.separatorStyle = .none
//        tableView.allowsSelection = false
//        tableView.sectionHeaderTopPadding = 0
//        return tableView
//    }()
//    
//    private let viewModel = RedeemScoreViewModel()
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//    }
//    
//    // MARK: - Setup
//    private func setupView() {
//        setupNavigationBar(isBackButton: true, delegate: self)
//        
//        view.backgroundColor = .wcBackground
//        view.addSubview(tableView)
//        
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
//            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
//        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
//    }
//}
//
//// MARK: - NavigationBarDelegate
//extension RedeemScoreViewController: NavigationBarDelegate {
//    func navBarDidTapBack(in vc: UIViewController) {
//        navigationController?.popViewController(animated: true)
//    }
//}
//
//// MARK: - UITableViewDelegate
//extension RedeemScoreViewController: UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        16
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = .clear
//        return headerView
//    }
//}
//
//// MARK: - UITableViewDataSource
//extension RedeemScoreViewController: UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        viewModel.numberOfSections()
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        viewModel.numberOfRows(in: section)
//    }
//    
//    func tableView(
//        _ tableView: UITableView,
//        cellForRowAt indexPath: IndexPath
//    ) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(
//            withIdentifier: SubscriptionHistoryTableViewCell.className,
//            for: indexPath
//        ) as! SubscriptionHistoryTableViewCell
//        
////        cell.configure(with: presenter?.historys?[indexPath.section])
//        return cell
//    }
//}
//
//// MARK: - SubscriptionHistoryViewProtocol
//extension RedeemScoreViewController {
//    
//    func showLoading() {
//        showLoader(.loading)
//    }
//    
//    func hideLoading() {
//        showLoader(.hidden)
//    }
//    
//    func reloadTableView() {
//        tableView.reloadData()
//    }
//}
//
//class RedeemScoreViewModel {
//    
//    enum RedeemScoreSection {
//        case totalScore(Int)
//        case giftVouchers([Cashback])
//        case cashback([Cashback])
//        
//        var title: String {
//            switch self {
//            case .totalScore: return "Total Score"
//            case .giftVouchers: return "Gift Vouchers"
//            case .cashback: return "Cashback"
//            }
//        }
//    }
//    
//    private(set) var couponList: RedeemScore?
//    private(set) var sections: [RedeemScoreSection] = []
//    
//    private let networkClient: NetworkClient
//    
//    init(networkClient: NetworkClient = NetworkClient()) {
//        self.networkClient = networkClient
//    }
//    
//    func getSubscriptionHistory(completion: @escaping () -> Void) {
//        Task { [weak self] in
//            guard let self else { return }
//            
//            var req = APIRequest(path: APIConstants.getCouponListURL)
//            req.method = .get
//            
//            do {
//                let response: APIResponse<RedeemScore> = try await self.networkClient.get(req)
//                await MainActor.run {
//                    guard let data = response.data else { return }
//                    self.couponList = data
//                    self.configureSections()
//                    completion()
//                }
//            } catch {
//                await MainActor.run {
//                    Log.info(error.localizedDescription)
//                    completion()
//                }
//            }
//        }
//    }
//    
//    private func configureSections() {
//        guard let couponList else { return }
//        var tempSections: [RedeemScoreSection] = []
//        
//        if let total = couponList.totalScore {
//            tempSections.append(.totalScore(total))
//        }
//        
//        if let vouchers = couponList.giftVouchers, !vouchers.isEmpty {
//            tempSections.append(.giftVouchers(vouchers))
//        }
//        
//        if let cashbacks = couponList.cashback, !cashbacks.isEmpty {
//            tempSections.append(.cashback(cashbacks))
//        }
//        
//        self.sections = tempSections
//    }
//    
//    // MARK: - TableView helpers
//    
//    func numberOfSections() -> Int {
//        return sections.count
//    }
//    
//    func numberOfRows(in section: Int) -> Int {
//        switch sections[section] {
//        case .totalScore, .giftVouchers, .cashback:
//            return 1
//        }
//    }
//    
//    func section(at index: Int) -> RedeemScoreSection? {
//        guard index < sections.count else { return nil }
//        return sections[index]
//    }
//}

