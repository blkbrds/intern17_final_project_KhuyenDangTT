//
//  DetailCell.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/1/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class DetailCell: UICollectionViewCell {
    
    // MARK: - IBOulets
    @IBOutlet private weak var detailImageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!

    // MARK: - Properties
    var viewModel: DetailCellViewModel? {
        didSet {
            updateCell()
        }
    }

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        updateCell()
    }

    // MARK: - Private func
    private func setupUI() {
        detailImageView.layer.cornerRadius = 20
    }

    private func updateCell() {
        detailImageView.downloadImage(with: viewModel?.photoItem?.URLImage ?? "") { image in
            self.detailImageView.image = image
        }
    }
}
