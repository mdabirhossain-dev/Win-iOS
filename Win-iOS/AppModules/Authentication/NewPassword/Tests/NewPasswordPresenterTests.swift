//
//
//  NewPasswordPresenterTests.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import XCTest
@testable import Win_iOS

final class NewPasswordPresenterTests: XCTestCase {

    func test_validation_empty_password_shows_errorLabel_message() {
        let presenter = NewPasswordPresenter(msisdn: "01700000000", otp: "1234")
        let view = ViewSpy()
        presenter.view = view

        presenter.didTapSubmit(newPassword: "", reenterPassword: "1")

        XCTAssertEqual(view.validationMessage, "নতুন পাসওয়ার্ড লিখুন")
    }

    private final class ViewSpy: NewPasswordViewProtocol {
        var validationMessage: String?
        func setLoading(_ isLoading: Bool) {}
        func showValidationError(_ message: String) { validationMessage = message }
        func clearValidationError() {}
        func showErrorToast(_ message: String) {}
        func showSuccessAndGoRoot() {}
    }
}
