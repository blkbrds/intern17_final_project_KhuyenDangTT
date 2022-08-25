//
//  CategoryViewModel.swift
//  FinalProject
//
//  Created by Khuyen Dang T.T. VN.Danang on 8/18/22.
//  Copyright © 2022 Asiantech. All rights reserved.
//

import Foundation

final class CategoryViewModel {

    // MARK: - Properties
    private var categories: [Category] = []
    var selectFilter: [String] = []

    // MARK: - Public func
    func getCategories(completion: @escaping APICompletion) {
        SearchService.shared().getCategories { [weak self] result in
            guard let this = self else { return completion(.failure(Api.Error.json)) }
            switch result {
            case .success(let categories):
                this.categories = categories
                completion(.success)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func numberOfItemInSection() -> Int {
        return categories.count
    }

    func viewModelForItem(at indexPath: IndexPath) -> CategoryCellViewModel {
        return CategoryCellViewModel(category: categories[indexPath.row])
    }

    func isSelected(at indexPath: IndexPath) -> Bool {
        return categories[indexPath.row].isSelected
    }
}
