//
//  DetailPrice.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/3/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper

final class Price: Mappable {

    var tier: Int?
    var currency: String?

    required init?(map: Map) { }

    func mapping(map: Map) {
        tier <- map["tier"]
        currency <- map["currency"]
    }
}
