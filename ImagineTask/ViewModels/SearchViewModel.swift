//
//  SearchViewModel.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import Foundation

final class SearchViewModel {

    private(set) var items: [GiphyItem] = []
    private var offset = 0
    private var isLoading = false
    private var hasMoreData = true
    private var currentQuery = ""

    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStatusChanged: ((Bool) -> Void)?

    // MARK: - Search
    func searchGifs(query: String, reset: Bool = false) {
        guard !isLoading else { return }

        onLoadingStatusChanged?(true)
        
        if reset || query != currentQuery {
            offset = 0
            items = []
            hasMoreData = true
            currentQuery = query
        }

        guard hasMoreData else { return }

        isLoading = true
        APIClient.shared.fetch(Endpoint.search(query: query, offset: offset)) { [weak self] (result: Result<GiphyResponse, NetworkError>) in
            guard let self = self else { return }
            self.isLoading = false
            onLoadingStatusChanged?(false)
            switch result {
            case .success(let response):
                self.items.append(contentsOf: response.data)
                self.offset += response.pagination.count
                self.hasMoreData = self.offset < response.pagination.totalCount
                self.onUpdate?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    // MARK: - Favorite Helper
    func toggleFavorite(for item: GiphyItem) {
        FavoritesManager.shared.toggle(item)
        onUpdate?()
    }

    func isFavorite(_ item: GiphyItem) -> Bool {
        FavoritesManager.shared.isFavorite(item)
    }
}
