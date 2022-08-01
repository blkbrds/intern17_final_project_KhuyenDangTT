//
//  NearTableViewCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/26/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class NearTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Properties
    var viewModel: NearViewModel? {
        didSet {
            collectionView.reloadData()
        }
    }

    // MARK: Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        configUINearCollectionView()
    }

    // MARK: - Private func
    private func configUINearCollectionView() {
        let nib = UINib(nibName: "NearCell", bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: "NearCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: Config.topContenInset, left: Config.leftContenInset, bottom: Config.bottomContenInset, right: Config.rightContenInset)
    }
}

// MARK: - UICollectionViewDataSource
extension NearTableViewCell: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.numberOfItemInSection() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearCell", for: indexPath) as? NearCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = viewModel?.viewModelForItem(at: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension NearTableViewCell: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Config.widthOfItem, height: Config.heightOfItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Config.minimumLineSpacingForSection
    }
}

// MARK: - UICollectionViewDelegate
extension NearTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == ((viewModel?.nearVenues.count ?? 0) - 3) {
            print("bbbb")
        }
    }
}

// MARK: - RecommendTableViewCell
extension NearTableViewCell {
    struct Config {
        static let minimumLineSpacingForSection: CGFloat = 20
        static let widthOfItem: CGFloat = (UIScreen.main.bounds.width - 40) / 2.5
        static let heightOfItem: CGFloat = UIScreen.main.bounds.height / 6.8
        static let topContenInset: CGFloat = 0
        static let bottomContenInset: CGFloat = 0
        static let leftContenInset: CGFloat = 20
        static let rightContenInset: CGFloat = 20
    }
}
