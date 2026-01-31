//
//
//  InvitationProtocols.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 13/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//



import UIKit

// MARK: - View
protocol InvitationViewProtocol: AnyObject {
    var presenter: InvitationPresenterProtocol? { get set }

    func setLoading(_ isLoading: Bool)
    func showToast(message: String, isError: Bool)

    func setInvitation(pointsText: String, codeText: String)
    func setInvitationUIVisible(_ isVisible: Bool)
}

// MARK: - Presenter
protocol InvitationPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapHistory(navigationController: UINavigationController?)
    func invitationCodeText() -> String
    func shareMessage() -> String?
}

// MARK: - Interactor
protocol InvitationInteractorInputProtocol: AnyObject {
    func fetchInvitationInfo()
}

protocol InvitationInteractorOutput: AnyObject {
    func invitationInfoFetched(_ response: InvitationResponse)
    func invitationInfoFailed(_ message: String)
}

// MARK: - Router
protocol InvitationRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToHistory(from navigationController: UINavigationController?)
}
