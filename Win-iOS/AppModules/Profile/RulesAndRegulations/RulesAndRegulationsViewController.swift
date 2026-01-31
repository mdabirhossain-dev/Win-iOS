//
//
//  RulesAndRegulationsViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 22/10/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class RulesAndRegulationsViewController: UIViewController {
    
    // MARK: - Properties
    private let rulesAndRegulationsURL: URL = {
        guard let url = URL(string: APIConstants.rulesAndRegulationsURL) else {
            fatalError("Invalid rules & regulations URL: \(APIConstants.rulesAndRegulationsURL)")
        }
        return url
    }()
    
    private lazy var webView: WebView = {
        let view = WebView(frame: .zero, url: rulesAndRegulationsURL)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Setup
    private func setupView() {
        setupNavigationBar(isBackButton: true, delegate: self)
        
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - NavigationBarDelegate
extension RulesAndRegulationsViewController: NavigationBarDelegate {
    func navBarDidTapBack(in vc: UIViewController) {
        navigationController?.popViewController(animated: true)
    }
}
