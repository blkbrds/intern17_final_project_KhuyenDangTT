//
//  Photo.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/3/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class Photo: Object, Mappable {

    var items = List<PhotoItem>()
    var itemsArray: [PhotoItem] = []

    convenience required init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }

    func mapping(map: Map) {
        itemsArray <- map["items"]
        items.removeAll()
        itemsArray.forEach { item in
            items.append(item)
        }
    }
}
