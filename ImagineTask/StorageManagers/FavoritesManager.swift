//
//  FavoritesManager.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import Foundation

final class FavoritesManager {

    static let shared = FavoritesManager()
    private let key = "favoriteGiphyItems"

    private var favorites: [GiphyItem] = []

    private init() {
        loadFavorites()
    }

    // MARK: - Public Methods

    func allFavorites() -> [GiphyItem] {
        return favorites
    }

    func isFavorite(_ item: GiphyItem) -> Bool {
        return favorites.contains(item)
    }

    func add(_ item: GiphyItem) {
        guard !favorites.contains(item) else { return }
        favorites.append(item)
        saveFavorites()
    }

    func remove(_ item: GiphyItem) {
        favorites.removeAll { $0 == item }
        saveFavorites()
    }

    func count() -> Int {
        return favorites.count
    }
    
    func toggle(_ item: GiphyItem) {
        if isFavorite(item) {
            remove(item)
        } else {
            add(item)
        }
    }

    // MARK: - Persistence

    private func saveFavorites() {
        do {
            let data = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to save favorites: \(error)")
        }
    }

    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: key) else { return }
        do {
            favorites = try JSONDecoder().decode([GiphyItem].self, from: data)
        } catch {
            print("Failed to load favorites: \(error)")
        }
    }
}
