//
//  FavoriteViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/25/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class FavoriteViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    var viewModel: FavoriteViewModel? 

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        configFavoriteTableViewCell()
    }
 
    private func setupData() {
        guard let viewModel = viewModel else { return }
        viewModel.getFavoriteVenues { done in
            DispatchQueue.main.async {
                if done {
                    self.tableView.reloadData()
                } else {
                    self.alert(msg: "", handler: nil)
                }
            }
        }
    }
    private func configFavoriteTableViewCell() {
        tableView.register(FavoriteCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension FavoriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        return viewModel.numberOfRowInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FavoriteCell.self)
        cell.viewModel = viewModel?.viewModelForItem(at: indexPath)
        cell.delegate = self
        return cell
    }
    
}
extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let viewModel = viewModel else { return 0.0 }
        return 70
    }
}
extension FavoriteViewController: FavoriteCellDelegate {
    func cell(_ cell: FavoriteCell, needPerformAction action: FavoriteCell.Action) {
        switch action {
        case .deleteFavorite(venue: let venue):
            viewModel?.deleteFavoriteVenue(venue: venue)
        }
    }
}
