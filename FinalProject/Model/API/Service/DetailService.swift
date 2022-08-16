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
    static var sharedInstance: DetailService = {
        let shareDetailService = DetailService()
        return shareDetailService
    }()

    var params: [String: Any] {
        var json: [String: Any] = [:]
        json["client_id"] = Api.Params.clientID
        json["client_secret"] = Api.Params.clientSecret
        json["v"] = Api.Params.version
        return json
    }

    // MARK: - Class func
    class func shared() -> DetailService {
        return sharedInstance
    }

    // MARK: - Private init()
    private init() {}

    // MARK: - Public func
    func getDetailVenueById(id: String, completion: @escaping Completion<DetailVenue>) {
        let urlString = Api.Path.detailURL + id
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
