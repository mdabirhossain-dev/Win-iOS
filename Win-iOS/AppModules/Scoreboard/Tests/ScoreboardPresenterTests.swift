//
//
//  ScoreboardPresenterTests.swift
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

final class ScoreboardPresenterTests: XCTestCase {

    func test_sections_are_empty_when_no_data() {
        let presenter = ScoreboardPresenter()
        let view = ViewSpy()
        presenter.view = view

        presenter.didFetchScoreboardCampaign(.init(
            campaignID: nil, title: nil, startDate: nil, endDate: nil,
            numberOfQuestions: nil, quizPlayDurationInSeconds: nil,
            campaignImage: nil, patchID: nil, clientID: nil,
            bengaliDuration: nil, quizType: nil, maxNumberOfDailyAttempts: nil,
            isMsisdnSpecific: nil, msisdnSpecificType: nil, leaderboardItems: nil,
            isAvailableForPlay: nil, participationPoint: nil, bonusPoint: nil,
            questionModalities: nil, leaderboardItemsList: [],
            dMinusOneLeaderboardItems: nil, campaignGifts: nil,
            ludoScoreBoard: nil, redemptionLeaderboard: nil
        ))

        XCTAssertTrue(presenter.sections.isEmpty)
        XCTAssertTrue(view.didReload)
    }

    // MARK: - Spy
    private final class ViewSpy: ScoreboardViewProtocol {
        var didReload = false
        func reload() { didReload = true }
        func showError(_ message: String) {}
        func setLoading(_ isLoading: Bool) {}
    }
}
