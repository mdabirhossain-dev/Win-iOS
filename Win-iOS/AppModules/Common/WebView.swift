//
//
//  WebView.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 22/10/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit
import WebKit

final class WebView: UIView {

    // MARK: - Bridge
    enum BridgeEvent: Equatable {
        case close
        case message(String)
    }

    // MARK: - State
    private var url: URL?

    // MARK: - Callbacks
    var onBridgeEvent: ((BridgeEvent) -> Void)?

    // MARK: - Constants
    private static let handlerName = "Android" // keep parity with your current setup

    // MARK: - UI Properties
    private lazy var webView: WKWebView = {
        let contentController = WKUserContentController()
        contentController.add(self, name: Self.handlerName)

        // Inject a bridge object so web can call `Android.dataToAndroid(...)` like Android.
        // Works even if web doesn't know about iOS messageHandlers.
        let bridgeJS = """
        (function() {
            if (window.Android && typeof window.Android.dataToAndroid === 'function') { return; }

            window.Android = {
                dataToAndroid: function(data) {
                    try {
                        window.webkit.messageHandlers.\(Self.handlerName).postMessage(String(data));
                    } catch (e) {}
                }
            };
        })();
        """
        let script = WKUserScript(source: bridgeJS, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        contentController.addUserScript(script)

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController

        let view = WKWebView(frame: .zero, configuration: configuration)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let loaderView: LoaderView = {
        let view = LoaderView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setState(.hidden)
        return view
    }()

    // MARK: - Init
    init(frame: CGRect, url: URL?) {
        self.url = url
        super.init(frame: frame)
        setupView()
        loadURL()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    deinit {
        webView.configuration.userContentController.removeScriptMessageHandler(forName: Self.handlerName)
    }

    // MARK: - Setup
    private func setupView() {
        addSubview(webView)
        addSubview(loaderView)

        webView.navigationDelegate = self

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: bottomAnchor),

            loaderView.topAnchor.constraint(equalTo: topAnchor),
            loaderView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loaderView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loaderView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Loading
    private func loadURL() {
        guard let url else { return }
        loaderView.setState(.loading)
        webView.load(URLRequest(url: url))
    }

    func loadNewURL(_ url: URL) {
        self.url = url
        loadURL()
    }
}

// MARK: - WKNavigationDelegate
extension WebView: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loaderView.setState(.loading)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        loaderView.setState(.hidden)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        loaderView.setState(.hidden)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        loaderView.setState(.hidden)
    }
}

// MARK: - WKScriptMessageHandler
extension WebView: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == Self.handlerName else { return }

        let text: String
        if let body = message.body as? String {
            text = body
        } else if let dict = message.body as? [String: Any] {
            text = String(describing: dict)
        } else {
            text = String(describing: message.body)
        }

        // Contract: if web sends "close" (or {"event":"close"}) we close.
        if text == "close" {
            onBridgeEvent?(.close)
            return
        }

        if let data = text.data(using: .utf8),
           let json = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any],
           let event = json["event"] as? String,
           event == "close" {
            onBridgeEvent?(.close)
            return
        }

        onBridgeEvent?(.message(text))
    }
}

//class WebView: UIView {
//    
//    // MARK: - State
//    private var url: URL?
//    
//    // MARK: - UI Properties
//    private let webView: WKWebView = {
//        let configuration = WKWebViewConfiguration()
//        let view = WKWebView(frame: .zero, configuration: configuration)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    private let loaderView: LoaderView = {
//        let view = LoaderView(frame: .zero)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.setState(.hidden)
//        return view
//    }()
//    
//    // MARK: - Init
//    init(frame: CGRect, url: URL?) {
//        self.url = url
//        super.init(frame: frame)
//        commonInit()
//        loadURL()
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        commonInit()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        commonInit()
//    }
//    
//    // MARK: - Setup
//    private func commonInit() {
//        setupView()
//    }
//    
//    private func setupView() {
//        addSubview(webView)
//        addSubview(loaderView)
//        
//        webView.navigationDelegate = self
//        
//        NSLayoutConstraint.activate([
//            webView.topAnchor.constraint(equalTo: topAnchor),
//            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            webView.bottomAnchor.constraint(equalTo: bottomAnchor),
//            
//            loaderView.topAnchor.constraint(equalTo: topAnchor),
//            loaderView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            loaderView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            loaderView.bottomAnchor.constraint(equalTo: bottomAnchor)
//        ])
//    }
//    
//    // MARK: - Loading
//    private func loadURL() {
//        guard let url = url else { return }
//        let request = URLRequest(url: url)
//        loaderView.setState(.loading)
//        webView.load(request)
//    }
//    
//    func loadNewURL(_ url: URL) {
//        self.url = url
//        loadURL()
//    }
//}
//
//// MARK: - WKNavigationDelegate
//extension WebView: WKNavigationDelegate {
//    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        loaderView.setState(.loading)
//    }
//
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        loaderView.setState(.hidden)
//    }
//
//    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        loaderView.setState(.hidden)
//    }
//
//    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
//        loaderView.setState(.hidden)
//    }
//}
