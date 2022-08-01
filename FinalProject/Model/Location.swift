//
//  Location.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/22/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper

class Location: Mappable {

    var address: String?
    var lat: Double?
    var long: Double?
    var distance: Int?
    var contextLine: String?

    required init?(map: Map) { }

    init() {}

    func mapping(map: Map) {
        address <- map["address"]
        lat <- map["lat"]
        long <- map["lng"]
        distance <- map["distance"]
        contextLine <- map["contextLine"]
    }

}
