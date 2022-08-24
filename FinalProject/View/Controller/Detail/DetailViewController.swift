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
    @IBOutlet private var starImageView: [UIImageView]!
    @IBOutlet private weak var seeMapButton: UIButton!
    @IBOutlet private weak var addressLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var likeLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel: DetailViewModel?

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail"
        setupDataDetail()
        setupDataSimilarVenue()
        configUICollectionView()
        configUI()
        configTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }

    // MARK: - Private func
    private func setupDataDetail() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getDetailById { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.updateUI()
                    this.collectionView.reloadData()
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    private func setupDataSimilarVenue() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getSimilarVenue { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.tableView.reloadData()
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    private func configUICollectionView() {
        collectionView.register(DetailCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

    private func configUI() {
        guard let viewModel = viewModel else { return }
        let image: UIImage? = viewModel.isFavorite() ? UIImage(named: Config.favoritedImage) : UIImage(named: Config.favoriteImage)
        favoriteButton.setImage(image, for: .normal)
        tableView.layer.cornerRadius = 20
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }

    private func configTableView() {
        tableView.register(SimilarCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func updateUI() {
        guard let viewModel = viewModel else { return }
        nameLabel.text = viewModel.detailVenue?.name
        ratingLabel.text = String(viewModel.detailVenue?.rating ?? 0) + Config.totalStar
        addressLabel.text = viewModel.showAddress()
        priceLabel.text = "Price: " + String(viewModel.detailVenue?.price?.tier ?? 0) + (viewModel.detailVenue?.price?.currency ?? "")
        likeLabel.text = viewModel.detailVenue?.like?.summary ?? ""
        for star in starImageView where star.tag > viewModel.numberOfRating() {
            star.image = UIImage(named: Config.starEmpty)
        }
    }

    // MARK: - IBActions
    @IBAction private func seeMapButtonTouchUpInside(_ sender: UIButton) {
//        let mapVC = MapViewController()
//        navigationController?.pushViewController(mapVC, animated: true)
    }

    @IBAction private func backButtonTouchUpInside(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func favoriteButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        let isFavorite = viewModel.isFavorite()
        if isFavorite {
            viewModel.deleteFavoriteVenue()
        } else {
            viewModel.addFavoriteVenue()
        }
        let image: UIImage? = !isFavorite ? UIImage(named: Config.favoritedImage) : UIImage(named: Config.favoriteImage)
        favoriteButton.setImage(image, for: .normal)
    }
}

// MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberOfItemsInSection() ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(DetailCell.self, forIndexPath: indexPath)
        cell.viewModel = viewModel?.viewModelForItem(at: indexPath)
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DetailViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Config.widthOfItem, height: collectionView.bounds.height + (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0.0))
    }
}

// MARK: - UITableViewDataSource
extension DetailViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRowInSectionSimilarVenue() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SimilarCell.self)
        cell.viewModel = viewModel?.viewModelForItemSimilarVenue(at: indexPath)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DetailViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        let detailVC = DetailViewController()
        detailVC.viewModel = DetailViewModel(id: viewModel.viewModelForItemSimilarVenue(at: indexPath).similarVenue.id )
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: Config
extension DetailViewController {

    struct Config {
        static let widthOfItem: CGFloat = UIScreen.main.bounds.width
        static let starEmpty: String = "star_empty"
        static let totalStar: String = "/10"
        static let favoritedImage: String = "favorited"
        static let favoriteImage: String = "favorite"
    }
}
