//
//  SearchViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/17/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import RealmSwift

final class SearchViewModel {

    // MARK: - Properties
    var searchVenues: [SearchVenue] = []
    var id: String = ""
    var searchVenue: SearchVenue?
    var query: String = ""
    var categoryId: [String] = []
    private var isShowDeleteHistoryButton: Bool = true

    // MARK: - Private func
    private func randomImage() -> String {
        let index = Int.random(min: 1, max: 13)
        return "coffee\(index)"
    }

    private func convertCategoryIdToString() -> String {
        var result: String = ""
        for category in categoryId {
            result += category + ","
        }
        return String(result.dropLast())
    }

    func numberOfRowInSection() -> Int {
        return searchVenues.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> SearchCellViewModel {
        return SearchCellViewModel(searchVenues: searchVenues[indexPath.row], isShowDeleteHistoryButton: isShowDeleteHistoryButton)
    }

    func isShowTableView() -> Bool {
        return searchVenues.isNotEmpty
    }
}


// MARK: Realm
extension SearchViewModel {

    func getHistoryVenues(completion: (Bool) -> Void) {
        do {
            let realm = try Realm()
            let results = realm.objects(SearchVenue.self)
            searchVenues = Array(results.reversed())
            self.isShowDeleteHistoryButton = true
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }

    func isSearched() -> Bool {
        guard let searchVenue = searchVenue else { return false }
        do {
            let realm = try Realm()
            let result = realm.objects(SearchVenue.self).first(where: { $0.id == searchVenue.id })
            return result != nil
        } catch {
            print(error)
            return false
        }
    }

    func addHistory() {
        guard let searchVenue = searchVenue else { return }
        do {
            let realm = try Realm()
            try realm.write {
                realm.create(SearchVenue.self, value: searchVenue, update: .all)
            }
        } catch {
            print(error)
        }
    }

    func deleteHistory() {
        do {
            let realm = try Realm()
            let result = realm.objects(SearchVenue.self).first(where: { $0.id == id })
            if let object = result {
                try realm.write {
                    realm.delete(object)
                }
            }
        } catch {
            print(error)
        }
    }
}

// MARK: APIs
extension SearchViewModel {

    func getVenues(completion: @escaping APICompletion) {
        if query.isEmpty {

        } else {
            guard let cordinate = LocationManager.shared().currentLocation?.coordinate else {
                return completion(.failure(Errors.initFailure))
            }
            let ll: String = "\(cordinate.latitude), \(cordinate.longitude)"
            let params = SearchService.Param(query: query, ll: ll, categoryId: convertCategoryIdToString())
            SearchService.shared().getVenues(params: params) { [weak self] result in
                guard let this = self else { return completion(.failure(Api.Error.json)) }
                switch result {
                case .success(let venues):
                    for venue in venues {
                        venue.image = this.randomImage()
                    }
                    this.isShowDeleteHistoryButton = false
                    this.searchVenues = venues
                    completion(.success)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
