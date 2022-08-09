//
//  FavoriteViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/5/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteViewModel {
    private (set) var favoriteVenues: [DetailVenue] = []
    var selectedVenue: DetailVenue?
    func getFavoriteVenues(completion: (Bool) -> ()) {
        do {
            let realm = try Realm()
            let results = realm.objects(DetailVenue.self)
            favoriteVenues = Array(results)
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
    }
    
//    func deleteFavoriteVenue() {
//        do {
//            let realm = try Realm()
//            let result = realm.objects(DetailVenue.self).filter("id == %@", id).first
//            if let object = result {
//                try realm.write {
//                    realm.delete(object)
//                }
//            }
//        } catch {
//            print(error)
//        }
//    }
    func deleteFavoriteVenue(venue: DetailVenue) {
        do {
                let realm = try Realm()
                try realm.write {
                    realm.delete(venue)
                }
        } catch {
            print(error)
        }
    }
    
    func numberOfRowInSection() -> Int {
        return favoriteVenues.count
    }
    func viewModelForItem(at indexPath: IndexPath) -> FavoriteCellViewModel {
        return FavoriteCellViewModel(favoriteVenue: favoriteVenues[indexPath.row])
    }
    
    
}
