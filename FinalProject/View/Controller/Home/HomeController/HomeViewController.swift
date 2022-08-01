//
//  HomeViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/25/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - Properties
    var viewModel: HomeViewModel?

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        configUI()
        configUIRecommendTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    // MARK: - Private func
    private func configUI() {
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

    private func setupData() {
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        self.setupDataRecommend()
        dispatchGroup.leave()
        dispatchGroup.enter()
        self.setupDataNear()
        dispatchGroup.leave()
        dispatchGroup.enter()
        self.setupDataOpenning()
        dispatchGroup.leave()
    }

    private func setupDataRecommend() {
        guard let viewModel = viewModel else { return }
        viewModel.getRecommendVenues { [weak self]result in
            guard let this = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    this.tableView.reloadData()
                }
            case .failure(let error):
                this.alert(msg: error.localizedDescription, handler: nil)
            }
        }
    }

    private func setupDataNear() {
        guard let viewModel = viewModel else { return }
        viewModel.getNearVenues { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    this.tableView.reloadData()
                }
            case .failure(let error):
                this.alert(msg: error.localizedDescription, handler: nil)
            }
        }
    }

    private func setupDataOpenning(limit: Int = 10) {
        guard let viewModel = viewModel else { return }
        viewModel.getOpenningVenues(limit: limit ) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    this.tableView.reloadData()
                }
            case .failure(let error):
                this.alert(msg: error.localizedDescription, handler: nil)
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
        guard let type = HomeViewModel.TypeRow(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        switch type {
        case .recommend:
            let recommendCell = tableView.dequeue(RecommendTableViewCell.self)
            recommendCell.viewModel = viewModel?.viewModelForRecommend()
            return recommendCell
        case .near:
            let nearCell = tableView.dequeue(NearTableViewCell.self)
            nearCell.viewModel = viewModel?.viewModelForNear()
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
            setupDataOpenning(limit: 20)
        }
    }
}

// MARK: - HomeViewController
extension HomeViewController {

    struct Config {
        static let borderWidthOfAvatarImage: CGFloat = 2
        static let borderColorOfAvatarImage = UIColor.orange.cgColor
        static let avatarImage = "user_female"
    }
}
