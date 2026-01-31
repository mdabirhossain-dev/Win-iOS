//
//
//  ProfilePresenter.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 11/11/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class ProfilePresenter: ProfilePresenterProtocol {

    weak var view: ProfileViewProtocol?
    var interactor: ProfileInteractorInputProtocol?
    var router: ProfileRouterProtocol?

    // MARK: - State
    private var summary: UserSummaryResponse?
    private var sections: [ProfileSection] = []

    private struct HeaderVM {
        let fullName: String
        let avatarURLString: String?
        let msisdn: String?
        let totalPoint: Int
        let totalScore: Int
    }
    private var headerVM: HeaderVM?

    // MARK: - Lifecycle
    func viewDidLoad() {
        buildSections() // initial skeleton
    }

    func viewWillAppear() {
        view?.setLoading(true)
        interactor?.fetchUserSummary()
    }

    func didRotate() {
        view?.reload()
    }

    // MARK: - Sections
    private func buildSections() {
        // Base static sections + dynamic campaign list (if any)
        var result: [ProfileSection] = []

        result.append(.userInfo)
        result.append(.points)
        result.append(.lakhpoti)
        result.append(.campaignScores)
        result.append(.journey)

        ProfileOption.allCases.forEach { result.append(.option($0)) }
        ProfileSocial.allCases.forEach { result.append(.social($0)) }

        result.append(.signOut)

        self.sections = result
    }

    private func mapSummary(_ summary: UserSummaryResponse) {
        let fullName = summary.fullName ?? ""
        let avatarURL = summary.avatarImage
        let msisdn = summary.msisdn

        // ⚠️ your API fields are messy; keep your old intent
        let totalPoint = summary.userPoint ?? summary.totalScore ?? 0
        let totalScore = summary.userScore ?? summary.totalScore ?? 0

        self.headerVM = HeaderVM(
            fullName: fullName,
            avatarURLString: avatarURL,
            msisdn: msisdn,
            totalPoint: totalPoint,
            totalScore: totalScore
        )
    }

    // MARK: - Collection
    func numberOfSections() -> Int { sections.count }

    func numberOfItems(in section: Int) -> Int {
        guard sections.indices.contains(section) else { return 0 }

        switch sections[section] {
        case .userInfo: return 1
        case .points: return 2
        case .lakhpoti: return 1
        case .campaignScores:
            return summary?.campaignWiseScores?.count ?? 0
        case .journey: return 1
        case .option: return 1
        case .social: return 1
        case .signOut: return 1
        }
    }

    func cellIdentifier(at indexPath: IndexPath) -> String {
        let section = sections[indexPath.section]
        switch section {
        case .userInfo:
            return ProfileUserInfoCell.className
        case .points:
            return PointsCell.className
        case .lakhpoti:
            return LakhpotiCampaignCell.className
        case .campaignScores:
            return CampaignWiseScoreCell.className
        case .journey:
            return ProfileUserProgressCell.className
        case .option:
            return ProfileOptionCell.className
        case .social:
            return ProfileSocialInfoCollectionViewCell.className
        case .signOut:
            return ProfileSignOutCell.className
        }
    }

    func configure(cell: UICollectionViewCell, at indexPath: IndexPath) {
        let section = sections[indexPath.section]

        switch section {
        case .userInfo:
            guard let cell = cell as? ProfileUserInfoCell else { return }
            cell.configure(
                name: headerVM?.fullName,
                avatarURLString: headerVM?.avatarURLString,
                number: headerVM?.msisdn
            )

        case .points:
            guard let cell = cell as? PointsCell else { return }
            let totalPoint = headerVM?.totalPoint ?? 0
            let totalScore = headerVM?.totalScore ?? 0

            if indexPath.item == 0 {
                cell.configure(type: .totalPoint(score: totalPoint))
            } else {
                cell.configure(type: .totalScore(score: totalScore))
            }

        case .lakhpoti:
            // Your cell has no config yet; keep it.
            _ = cell as? LakhpotiCampaignCell

        case .campaignScores:
            guard let cell = cell as? CampaignWiseScoreCell else { return }
            let list = summary?.campaignWiseScores ?? []
            guard list.indices.contains(indexPath.item) else { return }
            let item = list[indexPath.item]
            cell.configure(item.campaignTitle ?? "", item.score ?? 0)

        case .journey:
            guard let cell = cell as? ProfileUserProgressCell else { return }
            let journeyVM = summary?.userJourneyProgress?.toJourneyViewModel()
            cell.configure(journey: journeyVM)

        case .option(let option):
            guard let cell = cell as? ProfileOptionCell else { return }
            cell.configure(title: option.title, image: option.iconName)

        case .social(let social):
            guard let cell = cell as? ProfileSocialInfoCollectionViewCell else { return }
            cell.configure(
                SocialInfoModel(
                    animation: social.animation,
                    title: social.title,
                    description: social.description
                )
            )

        case .signOut:
            _ = cell as? ProfileSignOutCell
        }
    }

    // MARK: - Layout
    func sizeForItem(collectionWidth: CGFloat, at indexPath: IndexPath) -> CGSize {
        let fullWidth = collectionWidth - 32
        let section = sections[indexPath.section]

        switch section {
        case .userInfo:
            return CGSize(width: fullWidth, height: 150)

        case .points:
            let cellWidth = (fullWidth - 16) / 2
            return CGSize(width: cellWidth, height: 60)

        case .lakhpoti:
            return CGSize(width: fullWidth, height: 70)

        case .campaignScores:
            return CGSize(width: fullWidth, height: 60)

        case .journey:
            return CGSize(width: fullWidth, height: 110)

        case .option:
            return CGSize(width: fullWidth, height: 48)

        case .social:
            return CGSize(width: fullWidth, height: 60)

        case .signOut:
            return CGSize(width: fullWidth, height: 48)
        }
    }

    // MARK: - Selection
    func didSelectItem(at indexPath: IndexPath, navigationController: UINavigationController?) {
        let section = sections[indexPath.section]

        switch section {
        case .userInfo:
            break

        case .points:
            if indexPath.item == 0 {
                router?.navigate(to: .totalPoint(headerVM?.totalPoint ?? 0), from: navigationController)
            } else {
                router?.navigate(to: .totalScore(headerVM?.totalScore ?? 0), from: navigationController)
            }

        case .lakhpoti:
            break

        case .campaignScores:
            break

        case .journey:
            break

        case .option(let option):
            switch option {
            case .redeemScore:
                break
            case .requestPoint:
                router?.navigate(to: .requestPoint(summary), from: navigationController)
            case .giftPoint:
                router?.navigate(to: .giftPoint(summary), from: navigationController)
            case .pointHistory:
                router?.navigate(to: .subscriptionHistory, from: navigationController)
            case .helpAndSupport:
                router?.navigate(to: .helpAndSupport, from: navigationController)
            case .rate:
                router?.showRatePrompt()
            case .invite:
                router?.navigate(to: .invite, from: navigationController)
            case .rulesAndRegulations:
                router?.navigate(to: .rulesAndRegulations, from: navigationController)
            case .privacyPolicy:
                router?.navigate(to: .privacyPolicy, from: navigationController)
            }

        case .social(let social):
            router?.openSocial(social.linkType)

        case .signOut:
            router?.signOut(from: navigationController)
        }
    }

    // MARK: - Nav bar
    func didTapBack(from vc: UIViewController) {
        router?.dismissToHomeTab(from: vc)
    }

    func didTapUpdate(navigationController: UINavigationController?) {
        guard
            let vm = headerVM,
            let gender = summary?.gender,
            let userAvatarId = summary?.userAvatarId
        else { return }

        let userInfo = UpdateProfileRequest(
            fullName: vm.fullName,
            gender: gender,
            userAvatarId: "\(userAvatarId)"
        )
        router?.navigate(to: .updateProfile(userInfo, avatarUrl: vm.avatarURLString ?? ""), from: navigationController)
    }
}

// MARK: - Interactor Output
extension ProfilePresenter: ProfileInteractorOutputProtocol {
    func didReceiveUserSummary(_ summary: UserSummaryResponse) {
        self.summary = summary
        mapSummary(summary)
        buildSections()

        view?.setLoading(false)
        view?.reload()
    }

    func didFail(_ error: Error) {
        view?.setLoading(false)
        view?.showToast(message: error.localizedDescription, isError: true)
    }
}
