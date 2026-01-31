//
//
//  UpdateProfileProtocols.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

// MARK: - View
protocol UpdateProfileViewProtocol: AnyObject {
    var presenter: UpdateProfilePresenterProtocol? { get set }

    func setLoading(_ isLoading: Bool)

    func render(_ vm: UpdateProfileScreenViewModel)
    func showToast(_ message: String, isError: Bool)
    func showSuccessAndPop(title: String, message: String)
    func showAlert(title: String, message: String)
}

// MARK: - Presenter
protocol UpdateProfilePresenterProtocol: AnyObject {
    var view: UpdateProfileViewProtocol? { get set }
    var interactor: UpdateProfileInteractorInputProtocol? { get set }
    var router: UpdateProfileRouterProtocol? { get set }

    func viewDidLoad()
    func didTapBack()
    func didTapUpdateAvatar()
    func didTapSave(enteredName: String?)
    func didSelectAvatar(_ avatar: UserAvatar)
}

// MARK: - Interactor
protocol UpdateProfileInteractorInputProtocol: AnyObject {
    var output: UpdateProfileInteractorOutputProtocol? { get set }

    func fetchUserAvatar()
    func fetchAvatarList()
    func updateProfile(request: UpdateProfileRequest)
}

protocol UpdateProfileInteractorOutputProtocol: AnyObject {
    func didFetchUserAvatar(_ avatar: UserAvatar)
    func didFetchAvatarList(_ list: UserAvatarList)
    func didUpdateProfileSuccess(serverMessage: String?)
    func didFail(_ error: Error, serverMessage: String?)
}

// MARK: - Router
protocol UpdateProfileRouterProtocol: AnyObject {
    static func createModule(_ userInfo: UpdateProfileRequest, avatarUrl: String) -> UIViewController

    func dismiss(from view: UpdateProfileViewProtocol?)
    func presentAvatarPicker(
        from view: UpdateProfileViewProtocol?,
        avatars: UserAvatarList,
        selectedId: Int?,
        delegate: AvatarPickerViewControllerDelegate
    )
}

import UIKit

protocol AvatarPickerViewControllerDelegate: AnyObject {
    func avatarPicker(_ vc: AvatarPickerViewController, didConfirm avatar: UserAvatar)
}
