//
//  Like.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/3/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper

final class Like: Mappable {

    var summary: String?

    required init?(map: Map) { }

    func mapping(map: Map) {
        summary <- map["summary"]
    }
}
