//
//
//  ProfileViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 15/10/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//


import UIKit

final class ProfileViewController: UIViewController, ProfileViewProtocol {

    var presenter: ProfilePresenterProtocol?

    // MARK: - UI
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.dataSource = self
        cv.delegate = self
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .clear

        cv.register(ProfileUserInfoCell.self, forCellWithReuseIdentifier: ProfileUserInfoCell.className)
        cv.register(PointsCell.self, forCellWithReuseIdentifier: PointsCell.className)
        cv.register(LakhpotiCampaignCell.self, forCellWithReuseIdentifier: LakhpotiCampaignCell.className)
        cv.register(CampaignWiseScoreCell.self, forCellWithReuseIdentifier: CampaignWiseScoreCell.className)
        cv.register(ProfileUserProgressCell.self, forCellWithReuseIdentifier: ProfileUserProgressCell.className)
        cv.register(ProfileOptionCell.self, forCellWithReuseIdentifier: ProfileOptionCell.className)
        cv.register(ProfileSocialInfoCollectionViewCell.self, forCellWithReuseIdentifier: ProfileSocialInfoCollectionViewCell.className)
        cv.register(ProfileSignOutCell.self, forCellWithReuseIdentifier: ProfileSignOutCell.className)

        return cv
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.presenter?.didRotate()
        })
    }

    // MARK: - Setup
    private func setupView() {
        viewControllerTitle = "প্রোফাইল"

        let rightButtons = [
            NavigationBarButtonConfig(
                title: "আপডেট",
                image: UIImage(resource: .edit).withRenderingMode(.alwaysTemplate)
            )
        ]
        setupNavigationBar(rightButtons: rightButtons, isBackButton: true, delegate: self)

        view.backgroundColor = .wcBackground
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }

    // MARK: - ProfileViewProtocol
    func reload() {
        collectionView.reloadData()
    }

    func setLoading(_ isLoading: Bool) {
        showLoader(isLoading ? .loading : .hidden)
    }

    func showToast(message: String, isError: Bool) {
        Toast.show(message, style: isError ? .error : .success)
    }
}

// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter?.numberOfSections() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter?.numberOfItems(in: section) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let presenter else { return UICollectionViewCell() }
        let id = presenter.cellIdentifier(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
        presenter.configure(cell: cell, at: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        presenter?.sizeForItem(collectionWidth: collectionView.bounds.width, at: indexPath) ?? .zero
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.didSelectItem(at: indexPath, navigationController: navigationController)
    }
}

// MARK: - NavigationBarDelegate
extension ProfileViewController: NavigationBarDelegate {
    func navBarDidTapBack(in vc: UIViewController) {
        presenter?.didTapBack(from: vc)
    }

    func navBar(_ vc: UIViewController, didTapRightButtonAt index: Int) {
        if index == 0 {
            presenter?.didTapUpdate(navigationController: navigationController)
        }
    }
}
