//
//  FavoriteCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/8/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
protocol FavoriteCellDelegate: AnyObject {
    func cell(_ cell: FavoriteCell, needPerformAction action: FavoriteCell.Action)
}
final class FavoriteCell: UITableViewCell {

    enum Action {
        case deleteFavorite(venue: DetailVenue)
    }
    
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var photoImageView: UIImageView!
    
    var viewModel: FavoriteCellViewModel? {
        didSet {
            updateFavoriteCell()
        }
    }
    weak var delegate: FavoriteCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    override func layoutSubviews() {
        super.layoutSubviews()
        favoriteButton.layer.cornerRadius = favoriteButton.frame.height / 2
    }

    private func updateFavoriteCell() {
        guard let viewModel = viewModel else { return }
        
        photoImageView.downloadImage(with: viewModel.favoriteVenue.photos.first?.items.first?.URLImage ?? "") { image in
            self.photoImageView.image = image
        }
        nameLabel.text = viewModel.favoriteVenue.name
        addressLabel.text = viewModel.showAddress()
    }
    
    @IBAction func favoriteButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        delegate?.cell(self, needPerformAction: .deleteFavorite(venue: viewModel.favoriteVenue))
    }
}
