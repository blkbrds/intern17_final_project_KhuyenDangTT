//
//  Photo.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/3/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper

final class Photo: Mappable {
    
    var groups: [PhotoGroups]?

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        groups <- map["groups"]
    }
}
