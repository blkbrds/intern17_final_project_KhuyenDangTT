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

    // MARK: - Init
    init(openningVenues: [RecommendVenue]) {
        self.openningVenues = openningVenues
    }

    // MARK: - Public func
    func numberOfItemInSection() -> Int {
        return openningVenues.count
    }

    func isLoadMore(at indexPath: IndexPath) -> Bool {
        guard indexPath.row < openningVenues.count else { return false }
        return indexPath.row == openningVenues.count - 1
    }
    func viewModelForItem(at indexPath: IndexPath) -> RecommendViewModel {
        return RecommendViewModel(recommendVenue: openningVenues[indexPath.row])
    }
}
