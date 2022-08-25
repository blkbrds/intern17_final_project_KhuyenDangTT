//
//  HomeViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/25/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit
import CoreLocation

// MARK: - Protocol
protocol HomeViewControllerDelegate: AnyObject {
    func controller(_ controller: HomeViewController, needPerformAction action: HomeViewController.Action )
}

final class HomeViewController: UIViewController {

    // MARK: - Enum
    enum Action {
        case passIdDetail(id: String)
    }

    // MARK: - IBOutlets
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Properties
    var viewModel: HomeViewModel?
    let locationManager = CLLocationManager()

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configUIRecommendTableView()
        DispatchQueue.main.async {
            LocationManager.shared().startUpdating { [weak self] _ in
                guard let this = self else { return }
                this.configUI()
                this.setupDataRecommend()
                this.setupDataNear()
                this.setupDataOpenning()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Private func
    private func configUI() {
        if let viewModel = viewModel {
            titleLabel.text = Config.title + viewModel.getCity()
        } else {
            titleLabel.text = Config.title
        }
        avatarImageView.layer.borderColor = Config.borderColorOfAvatarImage
        avatarImageView.layer.borderWidth = Config.borderWidthOfAvatarImage
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.image = UIImage(named: Config.avatarImage)
    }

    private func configUIRecommendTableView() {
        tableView.register(RecommendTableViewCell.self)
        tableView.register(NearTableViewCell.self)
        tableView.register(OpeningTableViewCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
    }

    private func setupDataRecommend() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getRecommendVenues { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let city):
                    this.titleLabel.text = Config.title + city
                    this.tableView.reloadRows(at: [IndexPath(row: TypeRow.recommend.rawValue, section: Config.section)], with: .fade)
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    private func setupDataNear() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getNearVenues { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.tableView.reloadRows(at: [IndexPath(row: TypeRow.near.rawValue, section: Config.section)], with: .fade)
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    private func setupDataOpenning() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getOpenningVenues(isLoadMore: false) { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.tableView.reloadRows(at: [IndexPath(row: TypeRow.openning.rawValue, section: Config.section)], with: .fade)
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    private func loadMore(for cell: OpeningTableViewCell) {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getOpenningVenues(isLoadMore: true) { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    cell.viewModel = viewModel.viewModelForOpenning()
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    // MARK: - IBActions
    @IBAction private func searchButtonTouchUpInside(_ sender: UIButton) {
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.numberOfRowInSection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let type = TypeRow(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        switch type {
        case .recommend:
            let recommendCell = tableView.dequeue(RecommendTableViewCell.self)
            recommendCell.viewModel = viewModel?.viewModelForRecommend()
            recommendCell.delegate = self
            return recommendCell
        case .near:
            let nearCell = tableView.dequeue(NearTableViewCell.self)
            nearCell.viewModel = viewModel?.viewModelForNear()
            nearCell.delegate = self
            return nearCell
        case .openning:
            let openningCell = tableView.dequeue(OpeningTableViewCell.self)
            openningCell.delegate = self
            openningCell.viewModel = viewModel?.viewModelForOpenning()
            return openningCell
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let viewModel = viewModel else { return 0.0 }
        if let height = viewModel.heightForRow(at: indexPath) {
            return CGFloat(height)
        } else {
            return UITableView.automaticDimension
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - OpeningTableViewCellDelegate
extension HomeViewController: OpeningTableViewCellDelegate {

    func cell(_ cell: OpeningTableViewCell, needPerformAction action: OpeningTableViewCell.Action) {
        switch action {
        case .loadMore:
            loadMore(for: cell)
        case .showDetail(let id):
            let detailVC = DetailViewController()
            detailVC.viewModel = DetailViewModel(id: id)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - RecommendTableViewCellDelegate
extension HomeViewController: RecommendTableViewCellDelegate {
    func cell(_ cell: RecommendTableViewCell, needPerformAction action: RecommendTableViewCell.Action) {
        switch action {
        case .showDetail(let id):
            let detailVC = DetailViewController()
            detailVC.viewModel = DetailViewModel(id: id)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - NearTableViewCellDelegate
extension HomeViewController: NearTableViewCellDelegate {
    func cell(_ cell: NearTableViewCell, needPerformAction action: NearTableViewCell.Action) {
        switch action {
        case .showDetail(let id):
            let detailVC = DetailViewController()
            detailVC.viewModel = DetailViewModel(id: id)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

// MARK: - Config
extension HomeViewController {

    struct Config {
        static let borderWidthOfAvatarImage: CGFloat = 2
        static let borderColorOfAvatarImage = UIColor.orange.cgColor
        static let avatarImage = "user_female"
        static let section: Int = 0
        static let title: String = "Find the best coffee \nfor you in "
    }
}
