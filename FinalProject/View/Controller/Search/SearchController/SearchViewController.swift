//
//  SearchViewController.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/25/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import UIKit

final class SearchViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var filterButton: UIButton!
    @IBOutlet private weak var widthFilterButtonConstraint: NSLayoutConstraint!
    @IBOutlet private weak var noDataImageView: UIImageView!

    // MARK: - Properties
    var viewModel: SearchViewModel?
    var isSearch: Bool = false

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        getHistoryVenue()
        configSearchTableViewCell()
        configSearchBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        searchBar.resignFirstResponder()
    }

    func updateUI(isNeedReloadTableView: Bool = true) {
        let isShowTableView = viewModel?.isShowTableView() ?? false
        tableView.isHidden = !isShowTableView
        noDataImageView.isHidden = isShowTableView
        if isShowTableView && isNeedReloadTableView {
            tableView.reloadData()
        }
    }

    // MARK: - Private func
    private func getHistoryVenue() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getHistoryVenues { done in
            HUD.dismiss()
            DispatchQueue.main.async {
                if done {
                    self.updateUI()
                } else {
                    self.alert(msg: "Realm error!", handler: nil)
                }
            }
        }
    }

    private func configSearchTableViewCell() {
        tableView.register(SearchCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
    }

    private func configSearchBar() {
        widthFilterButtonConstraint.constant = 0
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
    }

    private func search() {
        guard let viewModel = viewModel else { return }
        HUD.show()
        viewModel.getVenues { [weak self] result in
            HUD.dismiss()
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    this.isSearch = true
                    this.updateUI()
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }
    
    private func deleteHistory(id: String, at indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.deleteHistory(id: id, at: indexPath) { [weak self] result in
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    break
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }
    
    private func addHistory() {
        guard let viewModel = viewModel else { return }
        viewModel.addHistory { [weak self] result in
            guard let this = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    break
                case .failure(let error):
                    this.alert(msg: error.localizedDescription, handler: nil)
                }
            }
        }
    }

    // MARK: - IBActions
    @IBAction private func filterButtonTouchUpInside(_ sender: Any) {
        let categoryVC = CategoryViewController()
        categoryVC.delegate = self
        categoryVC.modalPresentationStyle = .fullScreen
        navigationController?.present(categoryVC, animated: true, completion: nil)
    }

    @IBAction private func searchButtonTouchUpInside(_ sender: UIButton) {
        guard let viewModel = viewModel else { return }
        guard let searchText = searchBar.text, searchText.isNotEmpty else { return }
        searchBar.resignFirstResponder()
        viewModel.query = searchText
        search()
        widthFilterButtonConstraint.constant = Config.widthOfFilterButton

    }
}

// MARK: - UITableViewDataSource
extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel?.numberOfRowInSection() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else { return UITableViewCell() }
        let cell = tableView.dequeue(SearchCell.self)
        cell.viewModel = viewModel.viewModelForItem(at: indexPath)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Config.heightForRow
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = DetailViewController()
        detailVC.viewModel = DetailViewModel(id: viewModel.searchVenues[indexPath.row].id)
        viewModel.searchVenue = viewModel.searchVenues[indexPath.row]
        addHistory()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.isNotEmpty else {
            guard isSearch else { return }
            getHistoryVenue()
            widthFilterButtonConstraint.constant = 0
            return
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let viewModel = viewModel else { return }
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, searchText.isNotEmpty else { return }
        viewModel.query = searchText
        search()
        widthFilterButtonConstraint.constant = Config.widthOfFilterButton
    }
}

// MARK: - CategoryViewControllerDelegate
extension SearchViewController: CategoryViewControllerDelegate {

    func controller(_ controller: CategoryViewController, needPerformAction action: CategoryViewController.Action) {
        switch action {
        case .passFilter(let selectFilter):
            guard selectFilter.isNotEmpty else { return }
            guard let viewModel = viewModel else { return }
            viewModel.categoryId = selectFilter
            viewModel.query = searchBar.text ?? ""
            search()
        }
    }
}

// MARK: - SearchCellDelegate
extension SearchViewController: SearchCellDelegate {
    func cell(_ cell: SearchCell, needPerformAction action: SearchCell.Action) {
        switch action {
        case .deleteHistory(let id):
            guard let indexPath = tableView.indexPath(for: cell) else { return }
            deleteHistory(id: id, at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateUI(isNeedReloadTableView: false)
        }
    }
}

// MARK: - Config
extension SearchViewController {

    struct Config {
        static let heightForRow: CGFloat = 100
        static let widthOfFilterButton: CGFloat = 25
    }
}
