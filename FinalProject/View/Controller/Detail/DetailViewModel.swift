//
//  DetailViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/1/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import RealmSwift

final class DetailViewModel {
    
    // MARK: - Properties
    var id: String
    private (set) var detailVenue: DetailVenue?
    private (set) var photoItem =  List<PhotoItem>()
//    private (set) var favoriteVenues: [FavoriteRealm] = []

    init(id: String) {
        self.id = id
    }

    // MARK: - Public func
    func getDetailById(completion: @escaping APICompletion) {
        DetailService.shared().getDetailVenueById(id: id) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let detailVenue):
                this.detailVenue = detailVenue
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func showAddress() -> String {
        var address: String = ""
        for index in 0..<(detailVenue?.location?.formattedAddress.count ?? 0) {
            address += (detailVenue?.location?.formattedAddress[index] ?? "") + " "
        }
        return address + Config.seeMap
    }

    func numberOfRating() -> Int {
        return Int(round((detailVenue?.rating ?? 0) / 2))
    }

    func numberOfItemsInSection() -> Int {
        return detailVenue?.photos.first?.items.count ?? 0
    }

    func viewModelForItem(at indexPath: IndexPath) -> DetailCellViewModel {
        photoItem = detailVenue?.photos.first?.items ?? List<PhotoItem>()
      // photoItem = detailVenue?.photo?.groups.first?.items ?? []
        return DetailCellViewModel(photoItem: photoItem[indexPath.row])
    }

    func isFavorite() -> Bool {
        do {
            let realm = try Realm()
            let result = realm.objects(DetailVenue.self).filter("id == %@", id).first
            return result != nil
        } catch {
            print(error)
            return false
        }
    }

    func addFavoriteVenue() {
        guard let detailVenue = detailVenue else {
            return
        }
        do {
            let realm = try Realm()
            try realm.write {
                realm.create(DetailVenue.self, value: detailVenue, update: .all)
//                realm.add(detailVenue)
            }
        } catch {
            print(error)
        }
    }

    func deleteVenue() {
        do {
            let realm = try Realm()
            let result = realm.objects(DetailVenue.self).filter("id == %@", id).first
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

extension DetailViewModel {

    struct Config {
        static let seeMap: String = " (See map...)"
    }
}
