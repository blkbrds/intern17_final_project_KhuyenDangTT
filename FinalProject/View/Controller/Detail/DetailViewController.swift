//
//  DetailViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/1/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var detailView: UIView!
    @IBOutlet private var starImageView: [UIImageView]!
    @IBOutlet private weak var seeMapButton: UIButton!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var likeLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!

    // MARK: - Properties
    var viewModel: DetailViewModel?

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
        setupData()
        configUI()
        configUICollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Private func
    private func setupData() {
        HUD.show()
        guard let viewModel = viewModel else { return }
        viewModel.getDetailById { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    this.updateUI()
                    this.collectionView.reloadData()
                }
            case .failure(let error):
                this.alert(msg: error.localizedDescription, handler: nil)
            }
        }
    }

    private func configUI() {
        detailView.clipsToBounds = true
        detailView.layer.cornerRadius = 30
        detailView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func configUICollectionView() {
        let nib = UINib(nibName: "DetailCell", bundle: .main)
        collectionView.register(nib, forCellWithReuseIdentifier: "DetailCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.detailVenue?.name
        ratingLabel.text = String(viewModel.detailVenue?.rating ?? 0) + Config.totalStar
        seeMapButton.setTitle( viewModel.showAddress(), for: .normal)
        priceLabel.text = "Price: " + String(viewModel.detailVenue?.price?.tier ?? 0) + (viewModel.detailVenue?.price?.currency ?? "")
        likeLabel.text = viewModel.detailVenue?.like?.summary ?? ""
        for star in starImageView where star.tag > viewModel.numberOfRating() {
            star.image = UIImage(named: Config.starEmpty)
        }
    }
    
    @IBAction private func favoriteButtonTouchUpInside(_ sender: UIButton) {
    }
}

// MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItemsInSection() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCell", for: indexPath) as? DetailCell else {
            return UICollectionViewCell()
        }
        cell.viewModel = viewModel?.viewModelForItem(at: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Config.widthOfItem, height: Config.heightOfItem)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Config.minimumLineSpacingForSection
    }
}

// MARK: Config
extension DetailViewController {

    struct Config {
        static let minimumLineSpacingForSection: CGFloat = 20
        static let widthOfItem: CGFloat = (UIScreen.main.bounds.width - 20) * 0.8
        static let heightOfItem: CGFloat = UIScreen.main.bounds.height / 4
        static let starEmpty: String = "star_empty"
        static let totalStar: String = "/10"
    }
}
