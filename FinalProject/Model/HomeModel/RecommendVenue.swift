//
//  RecommendVenue.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/27/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper

final class RecommendVenue: Mappable {
    var venue: Venues?
    var image: String = ""

    required init?(map: Map) { }

    func mapping(map: Map) {
        venue <- map["venue"]
    }
}
