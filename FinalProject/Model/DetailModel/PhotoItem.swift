//
//  PhotoItem.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/3/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper

final class PhotoItem: Mappable {

    var prefix: String?
    var suffix: String?
    var URLImage: String {
        return (prefix ?? "") + Config.sizeOfImage + (suffix ?? "")
    }

    required init?(map: Map) { }

    func mapping(map: Map) {
        prefix <- map["prefix"]
        suffix <- map["suffix"]
    }
}

// MARK: - Config
extension PhotoItem {

    struct Config {
        static let sizeOfImage: String = "400x400"
    }
}
