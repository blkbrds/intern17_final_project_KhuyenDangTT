//
//  OpeningTableViewCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/26/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

protocol OpeningTableViewCellDelegate: AnyObject  {
    func cell(_ cell: OpeningTableViewCell, needPerformAction action: OpeningTableViewCell.Action )
}

final class OpeningTableViewCell: UITableViewCell {

    // MARK: - Enum
    enum Action {
        case loadMore
    }
    // MARK: - IBOulets
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Properties
    weak var delegate: OpeningTableViewCellDelegate?
    var viewModel: OpenningViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configUIOpenningCollectionView()
    }

    // MARK: - Private func
    private func configUIOpenningCollectionView() {
        let nib = UINib(nibName: "RecommendCell", bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: "RecommendCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: Config.topContenInset, left: Config.leftContenInset, bottom: Config.bottomContenInset, right: Config.rightContenInset)
    }
}

// MARK: - UICollectionViewDataSource
extension OpeningTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItemInSection() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecommendCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = viewModel?.viewModelForItem(at: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension OpeningTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Config.widthOfItem, height: Config.heightOfItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Config.minimumLineSpacingForSection
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Config.minimumInteritemSpacingForSection
    }
}

// MARK: - UICollectionViewDelegate
extension OpeningTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        if viewModel.isLoadMore(at: indexPath) {
            delegate?.cell(self, needPerformAction: .loadMore)
        }
    }
}

// MARK: - OpeningTableViewCell
extension OpeningTableViewCell {

    struct Config {
        static let minimumLineSpacingForSection: CGFloat = 20
        static let minimumInteritemSpacingForSection: CGFloat = 20
        static let widthOfItem: CGFloat = (UIScreen.main.bounds.width - 60) / 2
        static let heightOfItem: CGFloat = UIScreen.main.bounds.height / 5.5
        static let topContenInset: CGFloat = 20
        static let bottomContenInset: CGFloat = 0
        static let leftContenInset: CGFloat = 20
        static let rightContenInset: CGFloat = 20
    }
}
