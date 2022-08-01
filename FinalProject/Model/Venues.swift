//
//  Venues.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/22/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper

class Venues: Mappable {
    
    var location: Location?
    var id: String?
    var name: String?

    required init?(map: Map) {
    }

    init() { }

    func mapping(map: Map) {
        location <- map["location"]
        id <- map["id"]
        name <- map["name"]
    }
}
