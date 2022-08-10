//
//  FavoriteCellVieModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/8/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
class FavoriteCellViewModel {

    var favoriteVenue: DetailVenue

    init(favoriteVenue: DetailVenue) {
        self.favoriteVenue = favoriteVenue
    }

    func showAddress() -> String {
        var address: String = ""
        for index in 0..<(favoriteVenue.location?.formattedAddressList.count ?? 0) {
            address += (favoriteVenue.location?.formattedAddressList[index] ?? "") + " "
        }
        return address
    }
}
