//
//
//  ScoreboardCampaignsTableViewCell.swift
//  Win-iOS
//
//  Created by Md. Abir Hossain on 7/12/25.
//  Contact me if anything is needed:
//                             Phone: +880 1521-717367
//                             Email: mdabirhossain.dev@gmail.com
//  ©️ 2025 Md. Abir Hossain. All rights reserved.
//

import UIKit

// MARK: - Display Protocol (so UI can accept Campaign or ScoreboardCampaign)
protocol CampaignDisplayable {
    var campaignID: Int? { get }
    var title: String? { get }
}

extension Campaign: CampaignDisplayable {}
extension ScoreboardCampaign: CampaignDisplayable {}

// If your models are in the same module, just uncomment these:
// extension Campaign: CampaignDisplayable {}
// extension ScoreboardCampaign: CampaignDisplayable {}

// MARK: - Delegate
protocol ScoreboardCampaignsTableViewCellDelegate: AnyObject {
    func campaignsCell(_ cell: ScoreboardCampaignsTableViewCell, didSelect campaignID: Int)
}

// MARK: - TableView Cell
final class ScoreboardCampaignsTableViewCell: UITableViewCell,
                                              UICollectionViewDataSource,
                                              UICollectionViewDelegate {

    weak var delegate: ScoreboardCampaignsTableViewCellDelegate?

    private var items: [any CampaignDisplayable] = []
    private var selectedID: Int?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.allowsMultipleSelection = false
        collectionView.register(
            ScoreboardCampaignCollectionViewCell.self,
            forCellWithReuseIdentifier: ScoreboardCampaignCollectionViewCell.className
        )
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        items = []
        // keep selectedID if you want persistent selection across reuse
        // selectedID = nil
        collectionView.reloadData()
    }

    // MARK: - Public Configure
    func configure(_ campaignList: [any CampaignDisplayable]) {
        items = campaignList

        if let sel = selectedID,
           items.contains(where: { ($0.campaignID ?? Int.min) == sel }) {
            // keep selection
        } else {
            selectedID = items.first?.campaignID
        }

        collectionView.reloadData()

        if let sel = selectedID,
           let idx = items.firstIndex(where: { ($0.campaignID ?? Int.min) == sel }) {
            collectionView.selectItem(
                at: IndexPath(item: idx, section: 0),
                animated: false,
                scrollPosition: []
            )
        }
    }

    // Optional convenience overloads (so you can keep calling configure([Campaign]))
    func configure(_ campaignList: [Campaign]) {
        configure(campaignList as [any CampaignDisplayable])
    }

    func configure(_ campaignList: [ScoreboardCampaign]) {
        configure(campaignList as [any CampaignDisplayable])
    }

    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ScoreboardCampaignCollectionViewCell.className,
            for: indexPath
        ) as! ScoreboardCampaignCollectionViewCell

        cell.title = items[indexPath.item].title
        return cell
    }

    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = items[indexPath.item].campaignID ?? 0
        selectedID = id

        collectionView.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )

        delegate?.campaignsCell(self, didSelect: id)
    }
}

// MARK: - CollectionView Cell
final class ScoreboardCampaignCollectionViewCell: UICollectionViewCell {

    var title: String? { didSet { button.setTitle(title, for: .normal) } }

    private let button: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false // <-- cell handles taps
        button.titleLabel?.font = .winFont(.semiBold, size: .small)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        button.applyCornerRadious(20)
        button.applyShadow()
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isSelected: Bool {
        didSet { applySelectionUI() }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        title = nil
        applySelectionUI()
    }

    private func setupView() {
        contentView.addSubview(button)
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
        applySelectionUI()
    }

    private func applySelectionUI() {
        button.backgroundColor = isSelected ? .wcVelvet : .white
        button.setTitleColor(isSelected ? .white : .wcVelvet, for: .normal)
    }
}

//protocol ScoreboardCampaignsTableViewCellDelegate: AnyObject {
//    func campaignsCell(_ cell: ScoreboardCampaignsTableViewCell, didSelect campaignID: Int)
//}
//
//final class ScoreboardCampaignsTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
//
//    weak var delegate: ScoreboardCampaignsTableViewCellDelegate?
//
//    private var items: [Campaign] = []
//    private var selectedID: Int?
//
//    private lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.minimumLineSpacing = 8
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        layout.itemSize = UICollectionViewFlowLayout.automaticSize
//
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        collectionView.backgroundColor = .wcBackground
//        collectionView.showsHorizontalScrollIndicator = false
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        collectionView.allowsMultipleSelection = false
//        collectionView.register(ScoreboardCampaignCollectionViewCell.self,
//                    forCellWithReuseIdentifier: ScoreboardCampaignCollectionViewCell.className)
//        return collectionView
//    }()
//
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//
//        contentView.addSubview(collectionView)
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            collectionView.heightAnchor.constraint(equalToConstant: 52)
//        ])
//    }
//
//    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//
//    func configure(_ campaignList: [Campaign]) {
//        items = campaignList
//
//        if let sel = selectedID,
//           items.contains(where: { ($0.campaignID ?? Int.min) == sel }) {
//            // keep selection
//        } else {
//            selectedID = items.first?.campaignID
//        }
//
//        collectionView.reloadData()
//
//        if let sel = selectedID,
//           let idx = items.firstIndex(where: { ($0.campaignID ?? Int.min) == sel }) {
//            collectionView.selectItem(at: IndexPath(item: idx, section: 0),
//                                      animated: false,
//                                      scrollPosition: [])
//        }
//    }
//
//    // MARK: - DataSource
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        items.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: ScoreboardCampaignCollectionViewCell.className,
//            for: indexPath
//        ) as! ScoreboardCampaignCollectionViewCell
//
//        cell.title = items[indexPath.item].title
//        return cell
//    }
//
//    // MARK: - Delegate
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let id = items[indexPath.item].campaignID ?? 0
//        selectedID = id
//        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
//        delegate?.campaignsCell(self, didSelect: id)
//    }
//}
//
//final class ScoreboardCampaignCollectionViewCell: UICollectionViewCell {
//
//    var title: String? { didSet { button.setTitle(title, for: .normal) } }
//
//    private let button: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.isUserInteractionEnabled = false // <-- cell handles taps
//        button.titleLabel?.font = .winFont(.semiBold, size: .small)
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
//        button.applyCornerRadious(20)
//        button.applyShadow()
//        return button
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//
//    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//
//    override var isSelected: Bool { didSet { applySelectionUI() } }
//    override func prepareForReuse() { super.prepareForReuse(); title = nil }
//    
//    private func setupView() {
//        contentView.addSubview(button)
//        NSLayoutConstraint.activate([
//            button.topAnchor.constraint(equalTo: contentView.topAnchor),
//            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            button.heightAnchor.constraint(equalToConstant: 40)
//        ])
//
//        applySelectionUI()
//    }
//
//    private func applySelectionUI() {
//        button.backgroundColor = isSelected ? .wcVelvet : .white
//        button.setTitleColor(isSelected ? .white : .wcVelvet, for: .normal)
//    }
//}
