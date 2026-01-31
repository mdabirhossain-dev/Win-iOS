//
//
//  UpdateProfilePresenter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/11/25.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class UpdateProfilePresenter: UpdateProfilePresenterProtocol {

    weak var view: UpdateProfileViewProtocol?
    var interactor: UpdateProfileInteractorInputProtocol?
    var router: UpdateProfileRouterProtocol?

    // Inputs
    private let userInfo: UpdateProfileRequest
    private let initialAvatarURL: String

    // State snapshot
    private var originalName: String
    private var originalAvatarId: Int?
    private var selectedAvatarId: Int?
    private var selectedAvatarURL: String?

    private var avatarList: UserAvatarList = []

    init(userInfo: UpdateProfileRequest, avatarUrl: String) {
        self.userInfo = userInfo
        self.initialAvatarURL = avatarUrl

        let seededName = userInfo.fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        self.originalName = seededName
        self.originalAvatarId = Int(userInfo.userAvatarId)
        self.selectedAvatarId = Int(userInfo.userAvatarId)
        self.selectedAvatarURL = avatarUrl
    }

    func viewDidLoad() {
        render()
        view?.setLoading(true)
        interactor?.fetchUserAvatar()
        interactor?.fetchAvatarList()
    }

    func didTapBack() {
        router?.dismiss(from: view)
    }

    func didTapUpdateAvatar() {
        guard !avatarList.isEmpty else {
            view?.showAlert(title: "অপেক্ষা করুন", message: "অ্যাভাটার লোড হচ্ছে")
            return
        }

        router?.presentAvatarPicker(
            from: view,
            avatars: avatarList,
            selectedId: selectedAvatarId ?? originalAvatarId,
            delegate: view as? AvatarPickerViewControllerDelegate ?? DummyAvatarPickerDelegate()
        )
    }

    func didSelectAvatar(_ avatar: UserAvatar) {
        selectedAvatarId = avatar.userAvatarId
        selectedAvatarURL = avatar.imageSource
        render()
    }

    func didTapSave(enteredName: String?) {
        let newName = (enteredName ?? "").trimmingCharacters(in: .whitespacesAndNewlines)

        guard !newName.isEmpty else {
            view?.showToast("নাম খালি রাখা যাবে না", isError: true)
            return
        }

        let newAvatarId = selectedAvatarId ?? originalAvatarId

        let didChangeName = (newName != originalName)
        let didChangeAvatar = (newAvatarId != originalAvatarId)

        guard didChangeName || didChangeAvatar else {
            view?.showToast("আপডেট করার জন্য তথ্য পরিবর্তন করুন", isError: false)
            return
        }

        let req = UpdateProfileRequest(
            fullName: newName,
            gender: userInfo.gender,
            userAvatarId: newAvatarId.map(String.init) ?? userInfo.userAvatarId
        )

        view?.setLoading(true)
        interactor?.updateProfile(request: req)
    }

    private func render() {
        let msisdn = KeychainManager.shared.msisdn.dropLeading88().toBanglaNumberWithSuffix()
        let vm = UpdateProfileScreenViewModel(
            msisdnText: msisdn,
            userNameText: originalName, // set initially; view can show typed value separately
            avatarURL: selectedAvatarURL ?? initialAvatarURL
        )
        view?.render(vm)
    }
}

// MARK: - Interactor Output
extension UpdateProfilePresenter: UpdateProfileInteractorOutputProtocol {

    func didFetchUserAvatar(_ avatar: UserAvatar) {
        // Server truth overrides seed
        originalAvatarId = avatar.userAvatarId
        selectedAvatarId = avatar.userAvatarId
        selectedAvatarURL = avatar.imageSource ?? selectedAvatarURL
        view?.setLoading(false)
        render()
    }

    func didFetchAvatarList(_ list: UserAvatarList) {
        avatarList = list
        // don’t stop loading here; avatar fetch might still be running
        view?.setLoading(false)
    }

    func didUpdateProfileSuccess(serverMessage: String?) {
        view?.setLoading(false)

        // commit snapshot
        // NOTE: name in VC is user-entered; we don’t read UI here. The VC should pass it.
        // So we keep originalName as-is unless you want VC to call presenter again with final value.
        // We'll update name via view render callback pattern if needed later.

        view?.showSuccessAndPop(
            title: "সফল",
            message: serverMessage ?? "প্রোফাইল সফলভাবে আপডেট করা হয়েছে"
        )
    }

    func didFail(_ error: Error, serverMessage: String?) {
        view?.setLoading(false)
        view?.showToast(UserFacingErrorMapper.message(error: error, serverMessage: serverMessage), isError: true)
    }
}

// MARK: - Safety (avoid crash if view isn't delegate)
private final class DummyAvatarPickerDelegate: AvatarPickerViewControllerDelegate {
    func avatarPicker(_ vc: AvatarPickerViewController, didConfirm avatar: UserAvatar) { }
}
