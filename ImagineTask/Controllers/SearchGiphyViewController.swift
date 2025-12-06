//
//  SearchGiphyViewController.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import UIKit
import AVFoundation

final class SearchGiphyViewController: BaseGiphyViewController<SearchGiphyViewModel> {
    
    private let searchController = UISearchController(searchResultsController: nil)

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        addObserve()
        bindViewModel()
    }
    
    private func addObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteStatusChanged(_:)), name: .favoriteStatusChanged, object: nil)
    }
    
    private func initViews() {
        view.addSubview(contentView)
        contentView.anchorToFill(view: view)
        view.backgroundColor = AppColors.background
        title = TextConstants.searchTitleText
        initSearch()
    }

    private func initSearch() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = TextConstants.searchPlacholderText
        navigationItem.searchController = searchController
    }
}

// MARK: - SearchBar
extension SearchGiphyViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel.searchGifs(query: query, reset: true)
        searchBar.resignFirstResponder()
    }
}
