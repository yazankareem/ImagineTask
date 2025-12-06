//
//  FavoritesGiphyViewModel.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import Foundation

protocol FetchFavoritesDelegate {
    func fetchItems()
}

final class FavoritesGiphyViewModel: BaseGiphyDelegate, FetchFavoritesDelegate {
    
    var onError: ((String) -> Void)?
    
    var onLoadingStatusChanged: ((Bool) -> Void)?
    
    var items: [GiphyItem] = []
    var onUpdate: (() -> Void)?

    init() {}

    func fetchItems() {
        let favoriteIDs = FavoritesManager.shared.allFavorites()
        items = favoriteIDs
        onUpdate?()
    }

    func toggleFavorite(for item: GiphyItem) {
        FavoritesManager.shared.toggle(item)
        fetchItems()
    }
    
    func isFavorite(_ item: GiphyItem) -> Bool {
        return FavoritesManager.shared.isFavorite(item)
    }

    func favoriteCount() -> Int {
        FavoritesManager.shared.count()
    }
}
