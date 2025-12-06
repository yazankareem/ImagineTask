//
//  SearchViewController.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import UIKit
import AVFoundation

final class SearchViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let viewModel: SearchViewModel
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Init
    init(viewModel: SearchViewModel = SearchViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

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
        view.backgroundColor = AppColors.background
        title = TextConstants.searchTitleText
        initCollectionView()
        initSearch()
    }
    
    // MARK: - Setup
    private func initCollectionView() {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: SwiftyGiphyGridLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let collectionViewLayout = collectionView.collectionViewLayout as? SwiftyGiphyGridLayout
        {
            collectionViewLayout.delegate = self
        }
        
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
    
    @objc private func favoriteTapped(_ sender: UIButton) {
        let item = viewModel.items[sender.tag]
        viewModel.toggleFavorite(for: item)
        NotificationCenter.default.post(name: .addToFavorite, object: nil,
                                        userInfo: ["item": item])
        if let cell = collectionView.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? TrendingGifsCollectionViewCell {
            let isFavorite = viewModel.isFavorite(item)
            cell.favoriteButton.setTitle(isFavorite ? "★" : "☆", for: .normal)
        }
    }
    
    @objc private func handleFavoriteStatusChanged(_ notification: Notification) {
        if let id = notification.userInfo?["id"] as? String,
           let index = viewModel.items.firstIndex(where: { $0.id == id }) {
            
            let item = viewModel.items[index]

            let indexPath = IndexPath(item: index, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? TrendingGifsCollectionViewCell {
                let isFavorite = viewModel.isFavorite(item)
                cell.favoriteButton.setTitle(isFavorite ? "★" : "☆", for: .normal)
            }
        }
    }
}

// MARK: - SwiftyGiphyGridLayoutDelegate
extension SearchViewController: SwiftyGiphyGridLayoutDelegate {

    public func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat
    {
        guard let collectionViewLayout = collectionView.collectionViewLayout as? SwiftyGiphyGridLayout, let imageSet = viewModel.items[indexPath.row].imageSetClosestTo(width: collectionViewLayout.columnWidth) else {
            return 0.0
        }
        let titleHeight = (viewModel.items[indexPath.row].title?.heightWithConstrainedWidth(width: withWidth - 12 - 30, font: UIFont.boldSystemFont(ofSize: 14)) ?? 0.0)

        let descHeight = (viewModel.items[indexPath.row].title?.heightWithConstrainedWidth(width: withWidth - 8, font: UIFont.systemFont(ofSize: 12)) ?? 0.0)
        
        let height = descHeight + titleHeight + 14 + (imageSet.height?.cgFloatValue ?? 0.0)

        return AVMakeRect(aspectRatio: CGSize(width: imageSet.width!.cgFloatValue , height: height), insideRect: CGRect(x: 0.0, y: 0.0, width: withWidth, height: CGFloat.greatestFiniteMagnitude)).height
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
        if let collectionViewLayout = collectionView.collectionViewLayout as? SwiftyGiphyGridLayout, let imageSet = item.imageSetClosestTo(width: collectionViewLayout.columnWidth)
        {
            cell.configure(with: item, isFavorite: viewModel.isFavorite(item), imageSet: imageSet)
        }
        cell.favoriteButton.tag = indexPath.item
        cell.favoriteButton.addTarget(self, action: #selector(favoriteTapped(_:)), for: .touchUpInside)
        return cell
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
            viewModel.searchGifs(query: query)
        }
    }
}

// MARK: - SearchBar
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel.searchGifs(query: query, reset: true)
        searchBar.resignFirstResponder()
    }
}
