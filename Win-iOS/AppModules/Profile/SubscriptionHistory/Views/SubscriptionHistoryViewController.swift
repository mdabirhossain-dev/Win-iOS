//
//
//  SubscriptionHistoryViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class SubscriptionHistoryViewController: UIViewController {

    // MARK: - Presenter
    var presenter: SubscriptionHistoryPresenterProtocol?

    // MARK: - UI Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .wcBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.sectionHeaderTopPadding = 0
        tableView.register(
            SubscriptionHistoryTableViewCell.self,
            forCellReuseIdentifier: SubscriptionHistoryTableViewCell.className
        )
        return tableView
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.getSubscriptionHistory()
    }

    // MARK: - Setup
    private func setupView() {
        setupNavigationBar(isBackButton: true, delegate: self)

        view.backgroundColor = .wcBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
}

// MARK: - NavigationBarDelegate
extension SubscriptionHistoryViewController: NavigationBarDelegate {
    func navBarDidTapBack(in vc: UIViewController) {
        presenter?.router?.dismissView()
    }

    func navBar(_ vc: UIViewController, didTapRightButtonAt index: Int) {
        switch index {
        case 0:
            Log.info("Search")
        default:
            break
        }
    }
}

// MARK: - UITableViewDelegate
extension SubscriptionHistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 16 }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}

// MARK: - UITableViewDataSource
extension SubscriptionHistoryViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        presenter?.historys?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: SubscriptionHistoryTableViewCell.className,
            for: indexPath
        ) as! SubscriptionHistoryTableViewCell

        cell.configure(with: presenter?.historys?[indexPath.section])
        return cell
    }
}

// MARK: - SubscriptionHistoryViewProtocol
extension SubscriptionHistoryViewController: SubscriptionHistoryViewProtocol {

    func showLoading() { showLoader(.loading) }

    func hideLoading() { showLoader(.hidden) }

    func reloadTableView() { tableView.reloadData() }

    // ✅ Added
    func showToast(message: String, isError: Bool) {
        Toast.show(message, style: isError ? .error : .success)
    }
}

//final class SubscriptionHistoryViewController: UIViewController {
//    
//    // MARK: - Presenter
//    var presenter: SubscriptionHistoryPresenterProtocol?
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
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//        presenter?.getSubscriptionHistory()
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
//extension SubscriptionHistoryViewController: NavigationBarDelegate {
//    func navBarDidTapBack(in vc: UIViewController) {
//        presenter?.router?.dismissView()
//    }
//    
//    func navBar(_ vc: UIViewController, didTapRightButtonAt index: Int) {
//        switch index {
//        case 0:
//            Log.info("Search")
//        default:
//            break
//        }
//    }
//}
//
//// MARK: - UITableViewDelegate
//extension SubscriptionHistoryViewController: UITableViewDelegate {
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
//extension SubscriptionHistoryViewController: UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        presenter?.historys?.count ?? 0
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        1
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
//        cell.configure(with: presenter?.historys?[indexPath.section])
//        return cell
//    }
//}
//
//// MARK: - SubscriptionHistoryViewProtocol
//extension SubscriptionHistoryViewController: SubscriptionHistoryViewProtocol {
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
