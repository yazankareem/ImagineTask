//
//  TrendingGiphyViewController.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import UIKit
import AVFoundation

final class TrendingGiphyViewController: BaseGiphyViewController<TrendingGiphyViewModel> {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        FirstLaunchAlert.showIfNeeded(on: self)
        bindViewModel()
        addObserve()
        viewModel.fetchItems()
    }
    
    private func initViews() {
        view.backgroundColor = AppColors.background
        title = TextConstants.trendingTitleText
        initRefreshControl()
    }
    
    private func initRefreshControl() {
        refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
    }
    
    private func addObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteStatusChanged(_:)), name: .favoriteStatusChanged, object: nil
        )
    }
    
    @objc func didPullToRefresh() {
        collectionView.collectionViewLayout.invalidateLayout()
        viewModel.fetchItems(reset: true)
    }
}

extension TrendingGiphyViewController: UICollectionViewDelegateFlowLayout {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            viewModel.fetchItems(reset: false)
        }
    }
}
