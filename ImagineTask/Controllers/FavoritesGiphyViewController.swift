//
//  FavoritesGiphyViewController.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import UIKit
import AVFoundation

final class FavoritesGiphyViewController: BaseGiphyViewController<FavoritesGiphyViewModel> {
    
    private let headerView = FavoritesHeaderView()

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = TextConstants.favoriteTitleText
        bindViewModel()
        addObserve()
        viewModel.fetchItems()
    }
    
    // MARK: - Override SetupViews (DON'T add contentView again)
    override func setupViews() {
        view.backgroundColor = AppColors.background
        
        view.addSubview(contentView)
        contentView.anchorToFill(view: view)

        initHeaderView()
        initIndicatorView()
        setupCollectionView()
        initShowEmptyStateView()
    }
    
    func addObserve() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(refreshItems(_:)),
            name: .addToFavorite,
            object: nil
        )
    }
    
    // MARK: - Header
    private func initHeaderView() {
        contentView.addSubview(headerView)
        
        headerView.anchor(
            top: contentView.safeAreaLayoutGuide.topAnchor,
            leading: contentView.leadingAnchor,
            trailing: contentView.trailingAnchor,
            size: CGSize(width: 0, height: 50)
        )
        
        reloadFavoriteCount()
    }
    
    private func reloadFavoriteCount() {
        headerView.configure(count: viewModel.favoriteCount())
    }
    
    // MARK: - Collection
    override func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let layout = collectionView.collectionViewLayout as? SwiftyGiphyGridLayout {
            layout.delegate = self
        }
        
        registerCells()

        collectionView.backgroundColor = .clear
        
        contentView.addSubview(collectionView)

        collectionView.anchor(
            top: headerView.bottomAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.safeAreaLayoutGuide.bottomAnchor,
            trailing: contentView.trailingAnchor
        )
    }

    // MARK: - ViewModel Bind
    override func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.reloadFavoriteCount()
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
    
    // MARK: - Favorite Actions
    @objc override func favoriteTapped(_ sender: UIButton) {
        let item = viewModel.items[sender.tag]
        viewModel.toggleFavorite(for: item)
        
        NotificationCenter.default.post(
            name: .favoriteStatusChanged,
            object: nil,
            userInfo: ["id": item.id]
        )
    }
    
    @objc private func refreshItems(_ notification: Notification) {
        viewModel.fetchItems()
    }
}
