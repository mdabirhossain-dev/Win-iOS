//
//
//  HelpAndSupportPresenter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import Foundation

private enum HelpSupportUIError: LocalizedError {
    case emptyName
    case emptyEmail
    case invalidEmail
    case emptyMessage

    var errorDescription: String? {
        switch self {
        case .emptyName: return "আপনার নাম লিখুন"
        case .emptyEmail: return "আপনার ইমেইল লিখুন"
        case .invalidEmail: return "সঠিক ইমেইল দিন"
        case .emptyMessage: return "আপনার বার্তাটি লিখুন"
        }
    }
}

final class HelpAndSupportPresenter {

    private weak var view: HelpAndSupportViewProtocol?
    private let interactor: HelpAndSupportInteractorInputProtocol
    private let router: HelpAndSupportRouterProtocol

    init(
        view: HelpAndSupportViewProtocol,
        interactor: HelpAndSupportInteractorInputProtocol,
        router: HelpAndSupportRouterProtocol
    ) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension HelpAndSupportPresenter: HelpAndSupportPresenterProtocol {

    func viewDidLoad() { }

    func didTapSubmit(name: String?, phone: String?, email: String?, message: String?) {
        let name = (name ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let email = (email ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let message = (message ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !name.isEmpty else { view?.showError(message: HelpSupportUIError.emptyName.localizedDescription); return }
        guard !email.isEmpty else { view?.showError(message: HelpSupportUIError.emptyEmail.localizedDescription); return }
        guard email.isValidEmail else { view?.showError(message: HelpSupportUIError.invalidEmail.localizedDescription); return }
        guard !message.isEmpty else { view?.showError(message: HelpSupportUIError.emptyMessage.localizedDescription); return }
        
        let phoneTrimmed = (phone ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let finalMsisdn = phoneTrimmed.isEmpty ? KeychainManager.shared.msisdn : phoneTrimmed // "No-need"

        let request = HelpAndSupportRequest(
            name: name,
            message: message,
            msisdn: finalMsisdn,
            email: email
        )

        view?.setLoading(true)
        interactor.postHelpAndSupport(request: request)
    }

    func didTapBack() {
        router.dismiss(from: view)
    }
}

extension HelpAndSupportPresenter: HelpAndSupportInteractorOutputProtocol {

    func postHelpAndSupportSucceeded(responseMessage: String) {
        view?.setLoading(false)
        let msg = responseMessage.trimmingCharacters(in: .whitespacesAndNewlines)
        view?.showSuccess(message: msg.isEmpty ? "আপনার বার্তা সফলভাবে পাঠানো হয়েছে" : msg)
    }

    func postHelpAndSupportFailed(error: Error) {
        view?.setLoading(false)
        view?.showError(message: error.localizedDescription)
    }

    func postHelpAndSupportFailedWithServerMessage(_ message: String) {
        view?.setLoading(false)
        view?.showError(message: message)
    }
}

//final class HelpAndSupportPresenter {
//    
//    private weak var view: HelpAndSupportViewProtocol?
//    private let interactor: HelpAndSupportInteractorInputProtocol
//    private let router: HelpAndSupportRouterProtocol
//    
//    init(
//        view: HelpAndSupportViewProtocol,
//        interactor: HelpAndSupportInteractorInputProtocol,
//        router: HelpAndSupportRouterProtocol
//    ) {
//        self.view = view
//        self.interactor = interactor
//        self.router = router
//    }
//}
//
//extension HelpAndSupportPresenter: HelpAndSupportPresenterProtocol {
//    
//    func viewDidLoad() {
//        // any initial setup if needed
//    }
//    
//    func didTapSubmit(
//        name: String?,
//        phone: String?,
//        email: String?,
//        message: String?
//    ) {
//        guard let name, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
//            view?.showError(message: "আপনার নাম লিখুন")
//            return
//        }
//        
//        guard let email, !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
//            view?.showError(message: "আপনার ইমেইল লিখুন")
//            return
//        }
//        guard email.isValidEmail else { view?.showError(message: "সঠিক ইমেইল দিন"); return }
//        
//        guard let message, !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
//            view?.showError(message: "আপনার বার্তাটি লিখুন")
//            return
//        }
//        
//        // If msisdn really “No-need”, keep a default. Otherwise use phone from profile.
//        let finalMsisdn = "No-need" // phone ?? ""
//        
//        let request = HelpAndSupportRequest(
//            name: name,
//            message: message,
//            msisdn: finalMsisdn,
//            email: email ?? ""
//        )
//        
//        view?.setLoading(true)
//        interactor.postHelpAndSupport(request: request)
//    }
//
//    
//    func didTapBack() {
//        router.dismiss(from: view)
//    }
//}
//
//extension HelpAndSupportPresenter: HelpAndSupportInteractorOutputProtocol {
//    
//    func postHelpAndSupportSucceeded(responseMessage: String) {
//        view?.setLoading(false)
//        view?.showSuccess(message: responseMessage.isEmpty ? "আপনার বার্তা সফলভাবে পাঠানো হয়েছে" : responseMessage)
//    }
//    
//    func postHelpAndSupportFailed(error: Error) {
//        view?.setLoading(false)
//        view?.showError(message: error.localizedDescription)
//    }
//    
//    func postHelpAndSupportFailedWithServerMessage(_ message: String) {
//        view?.setLoading(false)
//        view?.showError(message: message)
//    }
//}
