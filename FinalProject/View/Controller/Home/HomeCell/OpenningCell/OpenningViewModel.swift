//
//  OpenningViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 7/26/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation
final class OpenningViewModel {

    // MARK: - Properties
    private (set) var openningVenues: [RecommendVenue] = []
    private (set) var isFull: Bool = false

    // MARK: - Init
    init(openningVenues: [RecommendVenue], isFull: Bool) {
        self.openningVenues = openningVenues
        self.isFull = isFull
    }

    // MARK: - Public func
    func numberOfItemInSection() -> Int {
        return openningVenues.count
    }

    func isLoadMore(at indexPath: IndexPath) -> Bool {
        guard indexPath.row < openningVenues.count else { return false }
        return indexPath.row == openningVenues.count - 4 && !isFull
    }

    func viewModelForItem(at indexPath: IndexPath) -> RecommendViewModel {
        return RecommendViewModel(recommendVenue: openningVenues[indexPath.row])
    }

    func getIdOpenningVenue(at indexPath: IndexPath) -> String {
        return openningVenues[indexPath.row].venue?.id ?? ""
    }
}
