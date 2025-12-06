//
//  FavoritesViewModel.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import Foundation

final class FavoritesViewModel {

    private(set) var items: [GiphyItem] = []
    var onUpdate: (() -> Void)?

    init() {}

    func loadFavorites() {
        let favoriteIDs = FavoritesManager.shared.allFavorites()
        self.items = favoriteIDs
        onUpdate?()
    }

    func toggleFavorite(for item: GiphyItem) {
        FavoritesManager.shared.toggle(item)
        loadFavorites()
    }
    
    func isFavorites(for item: GiphyItem) -> Bool {
        return FavoritesManager.shared.isFavorite(item)
    }

    func favoriteCount() -> Int {
        FavoritesManager.shared.count()
    }
}
