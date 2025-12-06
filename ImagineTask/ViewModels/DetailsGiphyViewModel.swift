//
//  DetailsGiphyViewModel.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import Foundation

final class DetailsGiphyViewModel {

    let item: GiphyItem
    var onUpdate: (() -> Void)?

    init(item: GiphyItem) {
        self.item = item
    }

    // MARK: - Favorite Handling
    func toggleFavorite() {
        FavoritesManager.shared.toggle(item)
        onUpdate?()
    }

    func isFavorite() -> Bool {
        FavoritesManager.shared.isFavorite(item)
    }
}
