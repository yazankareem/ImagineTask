//
//  HomeViewController.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import UIKit
import AVFoundation

final class TrendingGifsViewController: UIViewController {
    
    private var gifsTrendingCollectionView: UICollectionView!
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
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        FirstLaunchAlert.showIfNeeded(on: self)
        bindViewModel()
        addObserve()
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
    
    private func addObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteStatusChanged(_:)), name: .favoriteStatusChanged, object: nil)
    }
    
    // MARK: - setupCollectionView
    private func setupCollectionView() {
        gifsTrendingCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: SwiftyGiphyGridLayout())
        gifsTrendingCollectionView.delegate = self
        gifsTrendingCollectionView.dataSource = self
        gifsTrendingCollectionView.backgroundColor = .clear
        
        if let collectionViewLayout = gifsTrendingCollectionView.collectionViewLayout as? SwiftyGiphyGridLayout
        {
            collectionViewLayout.delegate = self
        }
    
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
        NotificationCenter.default.post(name: .addToFavorite, object: nil,
                                        userInfo: ["item": item])
        if let cell = gifsTrendingCollectionView.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? TrendingGifsCollectionViewCell {
            let isFavorite = viewModel.isFavorite(item)
            cell.favoriteButton.setTitle(isFavorite ? "★" : "☆", for: .normal)
        }
    }
    
    @objc private func handleFavoriteStatusChanged(_ notification: Notification) {
        if let id = notification.userInfo?["id"] as? String,
           let index = viewModel.items.firstIndex(where: { $0.id == id }) {
            
            let item = viewModel.items[index]

            let indexPath = IndexPath(item: index, section: 0)
            if let cell = gifsTrendingCollectionView.cellForItem(at: indexPath) as? TrendingGifsCollectionViewCell {
                let isFavorite = viewModel.isFavorite(item)
                cell.favoriteButton.setTitle(isFavorite ? "★" : "☆", for: .normal)
            }
        }
    }
}

// MARK: - SwiftyGiphyGridLayoutDelegate
extension TrendingGifsViewController: SwiftyGiphyGridLayoutDelegate {

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
extension TrendingGifsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            viewModel.fetchTrending()
        }
    }
}
