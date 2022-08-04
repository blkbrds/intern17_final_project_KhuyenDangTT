//
//  DetailViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/1/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class DetailViewModel {
    
    // MARK: - Properties
    var id: String
    private (set) var detailVenue: DetailVenue?
    private (set) var photoItem: [PhotoItem] = []

    init(id: String) {
        self.id = id
    }

    // MARK: - Public func
    func getDetailById(completion: @escaping APICompletion) {
        DetailService.getDetailVenueById(id: id) { [weak self] result in
            guard let this = self else { return }
            switch result {
            case .success(let detailVenue):
                this.detailVenue = detailVenue
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func showAddress() -> String {
        var address: String = ""
        for index in 0..<(detailVenue?.location?.formattedAddress?.count ?? 0) {
            address += (detailVenue?.location?.formattedAddress?[index] ?? "") + " "
        }
        return address + Config.seeMap
    }

    func numberOfRating() -> Int {
        return Int(round((detailVenue?.rating ?? 0) / 2))
    }

    func numberOfItemsInSection() -> Int {
        return detailVenue?.photo?.groups?.first?.items?.count ?? 0
    }

    func viewModelForItem(at indexPath: IndexPath) -> DetailCellViewModel {
        photoItem = detailVenue?.photo?.groups?.first?.items ?? []
        return DetailCellViewModel(photoItem: photoItem[indexPath.row])
    }
}

extension DetailViewModel {
    
    struct Config {
        static let seeMap: String = " (See map...)"
    }
}
