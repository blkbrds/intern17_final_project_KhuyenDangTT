//
//  NearCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/26/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class NearCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!

    // MARK: - Properties
    var viewModel: RecommendViewModel? {
        didSet {
            updateNearCell()
        }
    }

    // MARK: - Override func
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = Config.cornerRadius
        nameLabel.adjustsFontSizeToFitWidth = true
        addressLabel.adjustsFontSizeToFitWidth = true
    }

    private func updateNearCell() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.recommendVenue.venue?.name
        addressLabel.text = viewModel.recommendVenue.venue?.location?.address
        photoImageView.image = UIImage(named: viewModel.recommendVenue.image)
    }
}

// MARK: - NearCell
extension NearCell {
    struct Config {
        static let cornerRadius: CGFloat = 15
    }
}
