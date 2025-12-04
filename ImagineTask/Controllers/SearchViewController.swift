//
//  SearchViewController.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import UIKit

final class SearchViewController: UIViewController {
    
    private var collectionView: SelfSizingCollectionView!
    private let viewModel: SearchViewModel
    private let searchController = UISearchController(searchResultsController: nil)
    private var query: String? = nil
    
    // MARK: - Init
    init(viewModel: SearchViewModel = SearchViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let query = query {
            // MARK: viewModel.fetchTrending() Call here to refresh data when switch between tabBar to update favorite icon
            viewModel.searchGifs(query: query, reset: true)
        }
    }
    
    private func initViews() {
        view.backgroundColor = AppColors.background
        title = TextConstants.searchTitleText
        initCollectionView()
        initSearch()
    }
    
    // MARK: - Setup
    private func initCollectionView() {
        collectionView = SelfSizingCollectionView()
        collectionView.delegate = self
        collectionView.dataSource = self
        registerCells()
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        collectionView.anchorToFill(view: view)
    }

    private func registerCells() {
        collectionView.register(TrendingGifsCollectionViewCell.self, forCellWithReuseIdentifier: TrendingGifsCollectionViewCell.reuseIdentifier)
    }
    
    private func initSearch() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = TextConstants.searchPlacholderText
        navigationItem.searchController = searchController
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        viewModel.onError = { error in
            print("Error: \(error)")
        }
    }
}

// MARK: - CollectionView
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingGifsCollectionViewCell.reuseIdentifier, for: indexPath) as? TrendingGifsCollectionViewCell else {
            return UICollectionViewCell()
        }

        let item = viewModel.items[indexPath.item]
        cell.configure(with: item, isFavorite: viewModel.isFavorite(item))
        cell.favoriteButton.tag = indexPath.item
        cell.favoriteButton.addTarget(self, action: #selector(favoriteTapped(_:)), for: .touchUpInside)
        return cell
    }

    @objc private func favoriteTapped(_ sender: UIButton) {
        let item = viewModel.items[sender.tag]
        viewModel.toggleFavorite(for: item)
        collectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.items[indexPath.item]
        let detailsVC = DetailsViewController(item: item)
        navigationController?.pushViewController(detailsVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height - 100 {
            guard let query = searchController.searchBar.text, !query.isEmpty else { return }
            self.query = query
            viewModel.searchGifs(query: query)
        }
    }
}

// MARK: - SearchBar
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        self.query = query
        viewModel.searchGifs(query: query, reset: true)
        searchBar.resignFirstResponder()
    }
}
