//
//
//  AvatarPickerViewController.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 12/1/26.
//  Contact me if anything is needed: 
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2026 Md. Abir Hossain. All rights reserved.
//


import UIKit

class AvatarPickerViewController: UIViewController {
    
    weak var delegate: AvatarPickerViewControllerDelegate?

    private let avatars: UserAvatarList
    private var selectedId: Int?
    private var selectedAvatar: UserAvatar?

    // UI
    private let dimView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.black.withAlphaComponent(0.55)
        return v
    }()

    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .wcBackground
        v.applyCornerRadious(16)
        return v
    }()

    private let headerStack: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .horizontal
        s.alignment = .center
        return s
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "অ্যাভাটার নির্বাচন করুন"
        l.font = .winFont(.regular, size: .medium)
        return l
    }()

    private let closeButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(systemName: "xmark"), for: .normal)
        b.tintColor = .label
        return b
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate = self
        cv.register(AvaterCollectionViewCell.self, forCellWithReuseIdentifier: AvaterCollectionViewCell.className)
        return cv
    }()

    private let useAvatarButton: WinButton = {
        let button = WinButton(background: .solid(.wcVelvet))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("ঠিক আছে", for: .normal)
        return button
    }()

    init(avatars: UserAvatarList, initiallySelectedId: Int?) {
        self.avatars = avatars
        self.selectedId = initiallySelectedId
        self.selectedAvatar = avatars.first(where: { $0.userAvatarId == initiallySelectedId })
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        useAvatarButton.addTarget(self, action: #selector(didTapUseAvatar), for: .touchUpInside)

        dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackdrop)))
    }

    private func setupUI() {
        view.backgroundColor = .clear
        view.addSubviews([dimView, containerView])

        containerView.addSubview(headerStack)
        containerView.addSubview(collectionView)
        containerView.addSubview(useAvatarButton)

        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(UIView())
        headerStack.addArrangedSubview(closeButton)

        NSLayoutConstraint.activate([
            dimView.topAnchor.constraint(equalTo: view.topAnchor),
            dimView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            headerStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            headerStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),

            closeButton.heightAnchor.constraint(equalToConstant: 28),
            closeButton.widthAnchor.constraint(equalToConstant: 28),

            collectionView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 320),

            useAvatarButton.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            useAvatarButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            useAvatarButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            useAvatarButton.heightAnchor.constraint(equalToConstant: 48),
            useAvatarButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }

    @objc private func didTapClose() { dismiss(animated: true) }
    @objc private func didTapBackdrop() { dismiss(animated: true) }

    @objc private func didTapUseAvatar() {
        guard let selectedAvatar else {
            Toast.show("একটি অ্যাভাটার নির্বাচন করুন", style: .error)
            return
        }
        delegate?.avatarPicker(self, didConfirm: selectedAvatar)
        dismiss(animated: true)
    }
}

extension AvatarPickerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        avatars.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AvaterCollectionViewCell.className,
            for: indexPath
        ) as! AvaterCollectionViewCell

        let avatar = avatars[indexPath.item]
        cell.configure(
            avatar: avatar,
            isSelected: avatar.userAvatarId == selectedId,
            imageURLString: avatar.imageSource
        )
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let avatar = avatars[indexPath.item]
        selectedId = avatar.userAvatarId
        selectedAvatar = avatar
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let columns: CGFloat = 3
        let inset: CGFloat = 12
        let spacing: CGFloat = 12

        let totalSpacing = (inset * 2) + (spacing * (columns - 1))
        let width = (collectionView.bounds.width - totalSpacing) / columns
        return CGSize(width: width, height: width)
    }
}
