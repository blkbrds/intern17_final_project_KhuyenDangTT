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

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        updateCell()
    }

    // MARK: - Private func
    private func setupUI() {
        detailImageView.layer.cornerRadius = 20
        //        makeShadowCell()
    }

    private func updateCell() {
        detailImageView.image = UIImage(named: "coffee3")
    }

    private func makeShadowCell() {
        let shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: DetailViewController.Config.widthOfItem, height: DetailViewController.Config.heightOfItem))
        self.containerView.layer.masksToBounds = false
        self.containerView.layer.shadowColor = UIColor.gray.cgColor
        self.containerView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.containerView.layer.shadowOpacity = 0.7
        self.containerView.layer.shadowPath = shadowPath.cgPath
    }
}
