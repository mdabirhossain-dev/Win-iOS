//
//  ProfileViewProtocol.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 11/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - View
protocol ProfileViewProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? { get set }
    func reload()
    func setLoading(_ isLoading: Bool)
    func showToast(message: String, isError: Bool)
}

// MARK: - Presenter
protocol ProfilePresenterProtocol: AnyObject {
    var view: ProfileViewProtocol? { get set }
    var interactor: ProfileInteractorInputProtocol? { get set }
    var router: ProfileRouterProtocol? { get set }

    // Lifecycle
    func viewDidLoad()
    func viewWillAppear()
    func didRotate()

    // Collection
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func cellIdentifier(at indexPath: IndexPath) -> String
    func configure(cell: UICollectionViewCell, at indexPath: IndexPath)
    func sizeForItem(collectionWidth: CGFloat, at indexPath: IndexPath) -> CGSize
    func didSelectItem(at indexPath: IndexPath, navigationController: UINavigationController?)

    // Navigation bar
    func didTapBack(from vc: UIViewController)
    func didTapUpdate(navigationController: UINavigationController?)
}

// MARK: - Interactor
protocol ProfileInteractorInputProtocol: AnyObject {
    var output: ProfileInteractorOutputProtocol? { get set }
    func fetchUserSummary()
}

protocol ProfileInteractorOutputProtocol: AnyObject {
    func didReceiveUserSummary(_ summary: UserSummaryResponse)
    func didFail(_ error: Error)
}

// MARK: - Router
protocol ProfileRouterProtocol: AnyObject {
    static func createModule() -> UIViewController

    func dismissToHomeTab(from vc: UIViewController)
    func navigate(to destination: ProfileRoute, from navigationController: UINavigationController?)
    func showRatePrompt()
    func openSocial(_ type: SocialLinkType)
    func signOut(from navigationController: UINavigationController?)
}

// MARK: - Routes
enum ProfileRoute {
    case updateProfile(_ userInfo: UpdateProfileRequest, avatarUrl: String)
    case totalPoint(_ totalPoint: Int)
    case totalScore(_ totalScore: Int)
    case requestPoint(_ userSummery: UserSummaryResponse? = nil)
    case giftPoint(_ userSummery: UserSummaryResponse? = nil)
    case subscriptionHistory
    case helpAndSupport
    case invite
    case rulesAndRegulations
    case privacyPolicy
}
