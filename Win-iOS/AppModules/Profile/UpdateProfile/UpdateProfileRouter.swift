//
//
//  UpdateProfileRouter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class UpdateProfileRouter: UpdateProfileRouterProtocol {

    weak var viewController: UIViewController?

    static func createModule(_ userInfo: UpdateProfileRequest, avatarUrl: String) -> UIViewController {
        let view = UpdateProfileViewController()
        let presenter = UpdateProfilePresenter(userInfo: userInfo, avatarUrl: avatarUrl)
        let interactor = UpdateProfileInteractor()
        let router = UpdateProfileRouter()

        view.presenter = presenter

        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.output = presenter
        router.viewController = view

        view.inject(userInfo: userInfo, avatarUrl: avatarUrl)

        return view
    }

    func dismiss(from view: UpdateProfileViewProtocol?) {
        (view as? UIViewController)?.navigationController?.popViewController(animated: true)
    }

    func presentAvatarPicker(
        from view: UpdateProfileViewProtocol?,
        avatars: UserAvatarList,
        selectedId: Int?,
        delegate: AvatarPickerViewControllerDelegate
    ) {
        guard let vc = view as? UIViewController else { return }

        let picker = AvatarPickerViewController(
            avatars: avatars,
            initiallySelectedId: selectedId
        )
        picker.delegate = delegate
        picker.modalPresentationStyle = .overFullScreen
        picker.modalTransitionStyle = .crossDissolve
        vc.present(picker, animated: true)
    }
}
