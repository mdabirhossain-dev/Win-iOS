//
//
//  OnlineGamesViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 21/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit
import WebKit

final class OnlineGamesViewController: UIViewController {

    // MARK: - UI
    private lazy var webView: WebView = {
        let view = WebView(frame: .zero, url: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Properties
    private let gameID: Int
    private let viewModel = OnlineGamesViewModel()

    // MARK: - Init
    init(gameID: Int) {
        self.gameID = gameID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        tabbarVisibility(.hide)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindWebView()
        bindViewModel()
        viewModel.getGameURL(gameID)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Setup
    private func setupView() {
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func bindWebView() {
        webView.onBridgeEvent = { [weak self] event in
            guard let self else { return }

            switch event {
            case .close:
                self.navigationController?.popViewController(animated: true)

            case .message(let text):
                print("JS -> iOS:", text)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }

    private func bindViewModel() {
        viewModel.onURLLoaded = { [weak self] url in
            guard let self else { return }
            self.webView.loadNewURL(url)
        }

        viewModel.onError = { error in
            print("GAME API FAILED ❌", error)
        }
    }
}

final class OnlineGamesViewModel {

    var onURLLoaded: ((URL) -> Void)?
    var onError: ((Error) -> Void)?

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClient()) {
        self.networkClient = networkClient
    }

    func getGameURL(_ gameID: Int) {
        Task { [weak self] in
            guard let self else { return }

            var request = APIRequest(path: APIConstants.onlineGamesStartURL)
            request.method = .get
            request.query = ["onlineGameId": "\(gameID)"]

            do {
                let response: APIResponse<GameURLResponse> = try await networkClient.get(request)

                guard
                    let playUrl = response.data?.playUrl,
                    let url = URL(string: playUrl)
                else {
                    throw URLError(.badURL)
                }

                await MainActor.run {
                    self.onURLLoaded?(url)
                }
            } catch {
                await MainActor.run {
                    self.onError?(error)
                }
            }
        }
    }
}

struct GameURLResponse: Decodable {
    let isPremium: Bool?
    let playUrl: String?
}
