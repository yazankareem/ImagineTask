//
//  HomeViewController.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import UIKit

final class TrendingGifsViewController: UIViewController {
    
    private var gifsTrendingCollectionView: SelfSizingCollectionView!
    private let viewModel: TrendingGifsViewModel
    private var emptyStateView: EmptyStateView!
    private var indicatorView: IndicatorView!
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Init
    init(viewModel: TrendingGifsViewModel = TrendingGifsViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        FirstLaunchAlert.showIfNeeded(on: self)
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // MARK: viewModel.fetchTrending() Call here to refresh data when switch between tabBar to update favorite icon
        viewModel.fetchTrending()
    }
    
    // MARK: - initViews
    private func initViews() {
        view.backgroundColor = AppColors.background
        title = TextConstants.trendingTitleText
        setupCollectionView()
        initShowEmptyStateView()
        initIndicatorView()
    }
    
    // MARK: - setupCollectionView
    private func setupCollectionView() {
        gifsTrendingCollectionView = SelfSizingCollectionView()
        gifsTrendingCollectionView.delegate = self
        gifsTrendingCollectionView.dataSource = self
        gifsTrendingCollectionView.backgroundColor = .clear
        
        registerCells()
        
        // Add refresh control
        gifsTrendingCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        
        view.addSubview(gifsTrendingCollectionView)
        gifsTrendingCollectionView.anchorToFill(view: view)
    }
    
    private func registerCells() {
        gifsTrendingCollectionView.register(TrendingGifsCollectionViewCell.self, forCellWithReuseIdentifier: TrendingGifsCollectionViewCell.reuseIdentifier)
    }
    
    private func initShowEmptyStateView() {
        // Empty state view
        emptyStateView = EmptyStateView(message: TextConstants.noDataText)
        view.addSubview(emptyStateView)
        emptyStateView.anchorToFill(view: view)
        emptyStateView.isHidden = true
    }
    
    private func initIndicatorView() {
        indicatorView = IndicatorView()
        view.addSubview(indicatorView)
        indicatorView.anchorToFill(view: view)
    }
    
    private func updateEmptyState() {
        let isEmpty = viewModel.items.isEmpty
        emptyStateView.isHidden = !isEmpty
        gifsTrendingCollectionView.isHidden = isEmpty
    }
    
    @objc private func didPullToRefresh() {
        viewModel.resetAndFetchTrending { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                self?.viewModel.fetchTrending()
            }
        }
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.updateEmptyState()
                self?.gifsTrendingCollectionView.reloadData()
            }
        }
        
        viewModel.onError = { [weak self] error in
            print("Error: \(error)")
            DispatchQueue.main.async {
                self?.updateEmptyState()
            }
        }
        
        viewModel.onLoadingStatusChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.indicatorView.show()
                } else {
                    self?.indicatorView.hide()
                }
            }
        }
    }
    
    @objc private func favoriteTapped(_ sender: UIButton) {
        let item = viewModel.items[sender.tag]
        viewModel.toggleFavorite(for: item)
        gifsTrendingCollectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
    }
}

// MARK: - CollectionView
extension TrendingGifsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            viewModel.fetchTrending()
        }
    }
}
