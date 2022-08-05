//
//  DetailService.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/3/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Alamofire
import ObjectMapper

class DetailService {

    // MARK: - Properties
    static let shared = DetailService()
     let params: JSObject = [
        "client_id": HomeService.HomeParam.clientID,
        "client_secret": HomeService.HomeParam.clientSecret,
        "v": HomeService.HomeParam.version
    ]

    // MARK: - Class func
    func getDetailVenueById(id: String, completion: @escaping Completion<DetailVenue>) {
        let urlString = "https://api.foursquare.com/v2/venues/" + id
        api.request(method: .get, urlString: urlString, parameters: params) { result in
            switch result {
            case .success(let data):
                if let data = data as? JSObject,
                   let response = data["response"] as? JSObject,
                   let venue = response["venue"] as? JSObject {
                    guard let detailVenue = Mapper<DetailVenue>().map(JSONObject: venue) else {
                        return completion(.failure(Api.Error.json))
                    }
                    completion(.success(detailVenue))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
