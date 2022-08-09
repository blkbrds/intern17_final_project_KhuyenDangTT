//
//  Like.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/3/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class Like: Object, Mappable {

    @objc dynamic var summary: String = ""

    //required init?(map: Map) { }
    convenience required init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }
    func mapping(map: Map) {
        summary <- map["summary"]
    }
}
