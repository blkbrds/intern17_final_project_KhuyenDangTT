//
//  DetailLocation.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/3/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import ObjectMapper
import RealmSwift

final class DetailLocation: Object, Mappable {

    var formattedAddress = List<String>()
    var formattedAddressArray: [String] = []

    convenience required init?(map: Map) {
        self.init()
        self.mapping(map: map)
    }

    func mapping(map: Map) {
        formattedAddressArray <- map["formattedAddress"]
        formattedAddress.removeAll()
        formattedAddressArray.forEach { address in
            formattedAddress.append(address)
        }
    }
}
