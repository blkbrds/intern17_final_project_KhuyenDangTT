//
//  DetailVenues.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/3/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper

final class DetailVenue: Mappable {
    
    var name: String?
    var location: DetailLocation?
    var price: Price?
    var like: Like?
    var rating: Float?
    var photo: Photo?
    required init?(map: Map) { }

    init() {}

    func mapping(map: Map) {
        name <- map["name"]
        location <- map["location"]
        price <- map["price"]
        like <- map["likes"]
        rating <- map["rating"]
        photo <- map["photos"]
    }
}
