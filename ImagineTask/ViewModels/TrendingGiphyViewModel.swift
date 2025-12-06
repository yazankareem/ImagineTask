//
//  TrendingGiphyViewModel.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import Foundation

protocol FetchGiphyDelegate {
    func fetchItems(reset: Bool)
}

final class TrendingGiphyViewModel: BaseGiphyDelegate, FetchGiphyDelegate {
    
    internal var items: [GiphyItem] = []
    private var offset = 0
    private var isLoading = false
    private var isShowLoadingStatus = false
    private var hasMoreData = true

    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    var onLoadingStatusChanged: ((Bool) -> Void)?

    // MARK: - Fetch Items
    func fetchItems(reset: Bool = false) {
        guard !isLoading else { return }
        if !isShowLoadingStatus {
            onLoadingStatusChanged?(true)
            isShowLoadingStatus = !isShowLoadingStatus
        }
        if reset {
            resetValues()
        }
        guard hasMoreData else { return }

        isLoading = true
        APIClient.shared.fetch(Endpoint.trending(offset: offset)) { [weak self] (result: Result<GiphyResponse, NetworkError>) in
            guard let self = self else { return }
            self.onLoadingStatusChanged?(false)
            self.isLoading = false
            switch result {
            case .success(let response):
                if offset == 0 {
                    items = response.data
                } else {
                    self.items.append(contentsOf: response.data)
                }
                self.offset += response.pagination.count
                self.hasMoreData = self.offset < response.pagination.totalCount
                self.onUpdate?()
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }

    func pullToRefresh() {
        fetchItems(reset: true)
    }
    
    // MARK: - Favorite Helper
    func toggleFavorite(for item: GiphyItem) {
        FavoritesManager.shared.toggle(item)
        onUpdate?()
    }

    func isFavorite(_ item: GiphyItem) -> Bool {
        FavoritesManager.shared.isFavorite(item)
    }
    
    private func resetValues() {
        offset = 0
        hasMoreData = true
    }
}
