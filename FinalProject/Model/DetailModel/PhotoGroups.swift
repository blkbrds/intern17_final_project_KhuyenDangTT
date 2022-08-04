//
//  PhotoGroups.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/3/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper

final class PhotoGroups: Mappable {
    
    var items: [PhotoItem]?

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        items <- map["items"]
    }
}
