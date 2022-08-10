//
//  HomeService.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/22/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Alamofire
import ObjectMapper

class HomeService {

    // MARK: - Properties
    static var shareInstance: HomeService = {
        let shareHomeService = HomeService()
        return shareHomeService
    }()
    
    let params: JSObject = [
        "client_id": HomeParam.clientID,
        "client_secret": HomeParam.clientSecret,
        "v": HomeParam.version,
        "query": HomeParam.query]

    let addRecommendParams: JSObject = [
        "ll": "16.069954,108.218844",
        "limit": "10"]

    let addNearParams: JSObject = [
        "near": "Viet Nam, Da Nang",
        "limit": "10"]

    let addOpenningParams: JSObject = [
        "near": "Viet Nam, Da Nang",
        "openNow": "true"]

    // MARK: - Class func
    class func shared() -> HomeService {
        return shareInstance
    }

    // MARK: - Private init()
    private init() { }

    // MARK: - Public func
     func getRecommendVenues(completion: @escaping Completion<[RecommendVenue]>) {
        let recommendParams = params.merging(addRecommendParams) { _, _ in }
        let urlString = Api.Path.baseURL + Api.Path.recommendURL
        api.request(method: .get, urlString: urlString, parameters: recommendParams ) { result in
            switch result {
            case .success(let data):
                if let data = data as? JSObject,
                   let response = data["response"] as? JSObject,
                   let groups = response["groups"] as? JSArray {
                    var recommendVenue: [RecommendVenue] = []
                    guard let items = groups.first?["items"] as? JSArray else { return }
                        recommendVenue = Mapper<RecommendVenue>().mapArray(JSONArray: items)
                    for venue in recommendVenue {
                        venue.image = self.randomImage()
                    }
                    completion(.success(recommendVenue))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

     func getNearVenues(completion: @escaping Completion<[RecommendVenue]>) {
        let nearParams = params.merging(addNearParams) { _, _ in }
        let urlString = Api.Path.baseURL + Api.Path.recommendURL
        api.request(method: .get, urlString: urlString, parameters: nearParams ) { result in
            switch result {
            case .success(let data):
                if let data = data as? JSObject,
                   let response = data["response"] as? JSObject,
                   let groups = response["groups"] as? JSArray {
                    var recommendVenue: [RecommendVenue] = []
                        guard let items = groups.first?["items"] as? JSArray else { return }
                        recommendVenue = Mapper<RecommendVenue>().mapArray(JSONArray: items)
                    for venue in recommendVenue {
                        venue.image = self.randomImage()
                    }
                    completion(.success(recommendVenue))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

     func getOpenningVenues(limit: Int, completion: @escaping Completion<[RecommendVenue]>) {
        let openningVenueParams = params.merging(addOpenningParams) { _, _ in }
        let openningParams = openningVenueParams.merging(["limit": "\(limit)"]) { _, _ in }
        let urlString = Api.Path.baseURL + Api.Path.recommendURL
        api.request(method: .get, urlString: urlString, parameters: openningParams ) { result in
            switch result {
            case .success(let data):
                if let data = data as? JSObject,
                   let response = data["response"] as? JSObject,
                   let groups = response["groups"] as? JSArray {
                    var recommendVenue: [RecommendVenue] = []
                    guard let items = groups.first?["items"] as? JSArray else { return }
                        recommendVenue = Mapper<RecommendVenue>().mapArray(JSONArray: items)
                    for venue in recommendVenue {
                        venue.image = self.randomImage()
                    }
                    completion(.success(recommendVenue))
                } else {
                    completion(.failure(Api.Error.json))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - Private func
    private func randomImage() -> String {
        let index = Int.random(min: 1, max: 13)
        return "coffee\(index)"
    }
}

// MARK: - Define
extension HomeService {

    struct HomeParam {
        static let clientID = "PQXVYOXN4R55FNHKV05EUIF5OR4GZU4F2ITMOGIW3ZA1CKCZ"
        static let clientSecret = "JEG0HJKBHZNL4ADKBSMRVBFDDFVZWSFCTQ2P2A3UDQXAFAIK"
        static let version = "20211118"
        static let query = "coffee"
    }
}
