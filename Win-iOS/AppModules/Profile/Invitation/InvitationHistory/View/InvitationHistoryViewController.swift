//
//
//  InvitationHistoryViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 30/12/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class InvitationHistoryViewController: UIViewController {

    var presenter: InvitationHistoryPresenterProtocol?

    // MARK: - UI
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .wcBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            InvitationHistoryTableViewCell.self,
            forCellReuseIdentifier: InvitationHistoryTableViewCell.className
        )
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.sectionHeaderTopPadding = 0
        return tableView
    }()

    // MARK: - Lifecycle
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

// MARK: - View Protocol
extension InvitationHistoryViewController: InvitationHistoryViewProtocol {

    func showLoading() {
        showLoader(.loading)
    }

    func hideLoading() {
        showLoader(.hidden)
    }

    func reloadTableView() {
        tableView.reloadData()
    }

    func showError(_ message: String) {
        Toast.show(message, style: .error)
    }
}

// MARK: - NavigationBarDelegate
extension InvitationHistoryViewController: NavigationBarDelegate {
    func navBarDidTapBack(in vc: UIViewController) {
        presenter?.didTapBack()
    }
}

// MARK: - UITableViewDelegate
extension InvitationHistoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        16
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}

// MARK: - UITableViewDataSource
extension InvitationHistoryViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        // ✅ if not loaded / empty => show no cell
        presenter?.numberOfItems() ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: InvitationHistoryTableViewCell.className,
            for: indexPath
        ) as! InvitationHistoryTableViewCell

        cell.configure(with: presenter?.item(at: indexPath.section))
        return cell
    }
}

//class InvitationHistoryViewController: UIViewController {
//    
//    // MARK: - Presenter
//    
//    // MARK: - UI Properties
//    private let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.backgroundColor = .wcBackground
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(
//            InvitationHistoryTableViewCell.self,
//            forCellReuseIdentifier: InvitationHistoryTableViewCell.className
//        )
//        tableView.separatorStyle = .none
//        tableView.allowsSelection = false
//        tableView.sectionHeaderTopPadding = 0
//        return tableView
//    }()
//    
//    private let viewModel = InvitationHistoryViewModel()
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupView()
//        
//        viewModel.getInvitationHistory { result in
//            self.tableView.reloadData()
//        }
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
//extension InvitationHistoryViewController: NavigationBarDelegate {
//    func navBarDidTapBack(in vc: UIViewController) {
//        navigationController?.popViewController(animated: true)
//    }
//}
//
//// MARK: - UITableViewDelegate
//extension InvitationHistoryViewController: UITableViewDelegate {
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
//extension InvitationHistoryViewController: UITableViewDataSource {
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        viewModel.invitationList?.count ?? 0
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
//            withIdentifier: InvitationHistoryTableViewCell.className,
//            for: indexPath
//        ) as! InvitationHistoryTableViewCell
//        
//        cell.configure(with: viewModel.invitationList?[indexPath.section])
//        return cell
//    }
//}
//
//// MARK: - SubscriptionHistoryViewProtocol
//extension InvitationHistoryViewController {
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
//class InvitationHistoryViewModel {
//    
//    private(set) var invitationList: InvitationList?
//    
//    private let networkClient: NetworkClient
//    
//    init(networkClient: NetworkClient = NetworkClient()) {
//        self.networkClient = networkClient
//    }
//    
//    func getInvitationHistory(completion: @escaping (Result<Bool, Error>) -> Void) {
//        Task { [weak self] in
//            guard let self else { return }
//            
//            var req = APIRequest(path: APIConstants.invitationHistoryURL)
//            req.method = .get
//            do {
//                let response: APIResponse<InvitationList> = try await self.networkClient.get(req)
//                await MainActor.run {
//                    guard let data = response.data else { return }
//                    self.invitationList = data
//                    completion(.success(true))
//                }
//            } catch {
//                await MainActor.run {
//                    Log.info(error.localizedDescription)
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//}
