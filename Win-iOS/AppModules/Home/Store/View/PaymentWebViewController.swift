//
//
//  PaymentWebViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 22/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import UIKit
import WebKit

final class PaymentWebViewController: UIViewController {

    enum Result {
        case success
        case failure
    }

    var onResult: ((Result) -> Void)?

    private let urlString: String
    private var didFinishFlow = false

    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        return webView
    }()

    init(urlString: String) {
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        load()
    }

    private func setupView() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "Payment"

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark"),
            style: .plain,
            target: self,
            action: #selector(didTapClose)
        )

        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func load() {
        let trimmed = urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? trimmed

        print("🌐 Loading URL:", encoded)

        guard let url = URL(string: encoded) else {
            Toast.show("Invalid payment URL", style: .error)
            print("❌ Invalid URL:", encoded)
            return
        }

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        webView.load(request)
    }

    @objc private func didTapClose() {
        dismiss(animated: true)
    }

    private func handle(url: URL) {
        guard !didFinishFlow else { return }

        let value = url.absoluteString.lowercased()
        print("➡️ WebView URL:", value)

        if value.contains("success") {
            didFinishFlow = true
            onResult?(.success)
        } else if value.contains("fail") || value.contains("failed") {
            didFinishFlow = true
            onResult?(.failure)
        }
    }
}

extension PaymentWebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url { handle(url: url) }
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if let url = webView.url { handle(url: url) }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let url = webView.url { handle(url: url) }
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("❌ WebView navigation failed:", error)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("❌ WebView provisional navigation failed:", error)
    }
}
