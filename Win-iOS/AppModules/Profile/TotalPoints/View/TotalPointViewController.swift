//
//
//  PointDetailsViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 18/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class TotalPointViewController: UIViewController {
    
    // MARK: - Presenter
    var presenter: TotalPointPresenterProtocol?
    
    // MARK: - UI Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .wcBackground
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.sectionHeaderTopPadding = 0
        tableView.register(TotalPointAndScoreTableViewCell.self, forCellReuseIdentifier: TotalPointAndScoreTableViewCell.className)
        tableView.register(TotalPointAndScoreBreakdownTableViewCell.self, forCellReuseIdentifier: TotalPointAndScoreBreakdownTableViewCell.className)
        return tableView
    }()
    
    // MARK: - State
    private let totalScore: Int
    
    // MARK: - Init
    init(_ totalScore: Int) {
        self.totalScore = totalScore
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported. Use init(_:) instead.")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.setInitial(totalScore: totalScore)
        presenter?.viewDidLoad()
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
    }
}

// MARK: - NavigationBarDelegate
extension TotalPointViewController: NavigationBarDelegate {
    func navBarDidTapBack(in vc: UIViewController) {
        presenter?.router?.dismiss(from: self)
    }
}

// MARK: - UITableViewDelegate
extension TotalPointViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        16
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
}

// MARK: - UITableViewDataSource
extension TotalPointViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        presenter?.numberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfRows(in: section) ?? 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        presenter?.configureCell(tableView, at: indexPath) ?? UITableViewCell()
    }
}

// MARK: - TotalPointViewProtocol
extension TotalPointViewController: TotalPointViewProtocol {

    func reload() {
        tableView.reloadData()
    }

    func setLoading(_ isLoading: Bool) {
        showLoader(isLoading ? .loading : .hidden)
    }

    func showToast(message: String, isError: Bool) {
        Toast.show(message, style: isError ? .error : .success)
    }
}
