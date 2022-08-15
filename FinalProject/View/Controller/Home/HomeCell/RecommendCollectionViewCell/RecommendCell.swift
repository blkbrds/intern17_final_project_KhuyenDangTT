//
//  RecommendCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/26/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class RecommendCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!

    // MARK: - Properties
    var viewModel: RecommendViewModel? {
        didSet {
            updateRecommandCell()
        }
    }

    // MARK: - Override func
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = Config.cornerRadius
        nameLabel.adjustsFontSizeToFitWidth = true
    }

    // MARK: - Private func
    private func updateRecommandCell() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.recommendVenue.venue?.name
        addressLabel.text = viewModel.recommendVenue.venue?.location?.address
        photoImageView.image = UIImage(named: viewModel.recommendVenue.image)
    }
}
// MARK: - RecommendCell
extension RecommendCell {

    struct Config {
        static let cornerRadius: CGFloat = 15
    }
}
