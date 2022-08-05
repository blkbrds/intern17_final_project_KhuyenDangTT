//
//  HomeViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/26/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

// MARK: - Enum
enum TypeRow: Int, CaseIterable {
    case recommend = 0
    case near
    case openning

    var title: String {
        switch self {
        case .recommend:
            return "Recommend"
        case .near:
            return "Nearly"
        case .openning:
            return "Openning"
        }
    }
}

final class HomeViewModel {

    // MARK: - Properties
    private var recommendVenues: [RecommendVenue] = []
    private var nearVenues: [RecommendVenue] = []
    private var openningVenues: [RecommendVenue] = []

    // MARK: - Public func
    func numberOfRowInSection() -> Int {
        return TypeRow.allCases.count
    }

    func heightForRow(at indexPath: IndexPath) -> Float? {
        guard let type = TypeRow(rawValue: indexPath.row) else {
            return 0.0
        }
        switch type {
        case .recommend:
            return Config.heightRowOfRecommend
        case .near:
            return Config.heightRowOfNear
        case .openning:
            return Config.heightRowOfOpenning
        }
    }

    func getRecommendVenues(completion: @escaping APICompletion) {
        HomeService.shared().getRecommendVenues { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let recommendVenues):
                this.recommendVenues = recommendVenues
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getNearVenues(completion: @escaping APICompletion) {
        HomeService.shared().getNearVenues { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let nearVenues):
                this.nearVenues = nearVenues
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getOpenningVenues(limit: Int, completion: @escaping APICompletion) {
        HomeService.shared().getOpenningVenues(limit: limit) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let openningVenues):
                this.openningVenues.append(contentsOf: openningVenues)
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func viewModelForRecommend() -> RecommendTableViewViewModel {
        return RecommendTableViewViewModel(recommendVenues: recommendVenues)
    }

    func viewModelForNear() -> NearViewModel {
        return NearViewModel(nearVenues: nearVenues)
    }

    func viewModelForOpenning() -> OpenningViewModel {
        return OpenningViewModel(openningVenues: openningVenues)
    }

    func viewModelForDetail(at indexPath: IndexPath) -> DetailViewModel {
        return DetailViewModel(id: recommendVenues[indexPath.row].venue?.id ?? "")
    }
}

// MARK: - HomeViewModel
extension HomeViewModel {

    struct Config {
        static let heightRowOfRecommend: Float = 210
        static let heightRowOfNear: Float = 200
        static let heightRowOfOpenning: Float = 970
    }
}
