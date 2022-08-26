//
//  HomeViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/26/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import CoreLocation

// MARK: - Enum
enum TypeRow: Int, CaseIterable {
    case recommend = 0
    case near
    case openning

    var height: Float {
        switch self {
        case .recommend:
            return 210
        case .near:
            return 200
        case .openning:
            return 970
        }
    }
}

final class HomeViewModel {

    // MARK: - Properties
    private var recommendVenues: [RecommendVenue] = []
    private var nearVenues: [RecommendVenue] = []
    private (set) var openningVenues: [RecommendVenue] = []
    private var limit: Int = 10
    private var radius: Int = 1_000
    private var isFull: Bool = false

    // MARK: - Private func
    private func randomImage() -> String {
        let index = Int.random(min: 1, max: 13)
        return "coffee\(index)"
    }

    // MARK: - Public func
    func numberOfRowInSection() -> Int {
        return TypeRow.allCases.count
    }

    func heightForRow(at indexPath: IndexPath) -> Float? {
        guard let type = TypeRow(rawValue: indexPath.row) else {
            return 0.0
        }
        return type.height
    }

    func viewModelForRecommend() -> RecommendTableViewViewModel {
        return RecommendTableViewViewModel(recommendVenues: recommendVenues)
    }

    func viewModelForNear() -> NearViewModel {
        return NearViewModel(nearVenues: nearVenues)
    }

    func viewModelForOpenning() -> OpenningViewModel {
        return OpenningViewModel(openningVenues: openningVenues, isFull: isFull)
    }

    func viewModelForDetail(at indexPath: IndexPath) -> DetailViewModel {
        return DetailViewModel(id: recommendVenues[indexPath.row].venue?.id ?? "")
    }
}

// MARK: - API
extension HomeViewModel {

    func getNearVenues(completion: @escaping APICompletion) {
        guard let cordinate = LocationManager.shared().currentLocation?.coordinate else {
            completion(.failure(Errors.initFailure))
            return
        }
        let ll: String = "\(cordinate.latitude), \(cordinate.longitude)"
        let params = HomeService.Param(ll: ll, limit: limit, radius: radius)
        HomeService.getVenues(params: params) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let nearVenues):
                for venue in nearVenues {
                    venue.image = this.randomImage()
                }
                this.nearVenues = nearVenues
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func getRecommendVenues(completion: @escaping Completion<String>) {
        guard let cordinate = LocationManager.shared().currentLocation?.coordinate else {
            completion(.failure(Errors.initFailure))
            return
        }
        let location = CLLocation(latitude: cordinate.latitude, longitude: cordinate.longitude)
        location.placemark { placemark, error in
            guard let placemark = placemark else {
                completion(.failure(Errors.initFailure))
                return
            }
            let params = HomeService.Param(limit: self.limit, near: placemark.city)
            HomeService.getVenues(params: params) { [weak self] result in
                guard let this = self else { return }
                switch result {
                case .success(let recommendVenues):
                    for venue in recommendVenues {
                        venue.image = this.randomImage()
                    }
                    this.recommendVenues = recommendVenues
                    completion(.success(Define.title + (placemark.city ?? "")))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    func getOpenningVenues(isLoadMore: Bool, completion: @escaping APICompletion) {
        guard let cordinate = LocationManager.shared().currentLocation?.coordinate else {
            completion(.failure(Errors.initFailure))
            return
        }
        let offset: Int = openningVenues.count
        let location = CLLocation(latitude: cordinate.latitude, longitude: cordinate.longitude)
        location.placemark { placemark, error in
            guard let placemark = placemark else {
                completion(.failure(Errors.initFailure))
                return
            }
            let params = HomeService.Param(limit: self.limit, near: placemark.city, openNow: true, offset: offset)
            HomeService.getVenues(params: params) { [weak self] result in
                guard let this = self else { return }
                switch result {
                case .success(let openningVenues):
                    for venue in openningVenues {
                        venue.image = this.randomImage()
                    }
                    if isLoadMore {
                        this.openningVenues.append(contentsOf: openningVenues)
                        if openningVenues.count < this.limit {
                            this.isFull = true
                        }
                    } else {
                        this.openningVenues = openningVenues
                        this.isFull = false
                    }
                    completion(.success)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}

extension HomeViewModel {

    struct Define {
        static let title: String = "Find the best coffee \nfor you in "
    }
}
