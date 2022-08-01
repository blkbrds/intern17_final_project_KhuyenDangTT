//
//  RecommendTableViewCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/26/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class RecommendTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Properties
    var viewModel: RecommendTableViewViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configUIRecommendCollectionView()
    }

    // MARK: - Private func
    private func configUIRecommendCollectionView() {
        let nib = UINib(nibName: "RecommendCell", bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: "RecommendCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: Config.topContenInset, left: Config.leftContenInset, bottom: Config.bottomContenInset, right: Config.rightContenInset)
    }
}

// MARK: - UICollectionViewDataSource
extension RecommendTableViewCell: UICollectionViewDataSource {
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
extension RecommendTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Config.widthOfItem, height: Config.heightOfItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Config.minimumLineSpacingForSection
    }
}

// MARK: - RecommendTableViewCell
extension RecommendTableViewCell {
    struct Config {
        static let minimumLineSpacingForSection: CGFloat = 20
        static let widthOfItem: CGFloat = (UIScreen.main.bounds.width - 30) * 2 / 3
        static let heightOfItem: CGFloat = UIScreen.main.bounds.height / 5.5
        static let topContenInset: CGFloat = 0
        static let bottomContenInset: CGFloat = 0
        static let leftContenInset: CGFloat = 20
        static let rightContenInset: CGFloat = 20
    }
}
