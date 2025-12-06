//
//  BaseGiphyViewController.swift
//  ImagineTask
//
//  Created by Yazan on 06/12/2025.
//

import UIKit
import AVFoundation

protocol BaseGiphyDelegate: AnyObject {
    
    var items: [GiphyItem] { get set }
    var onUpdate: (() -> Void)? { get set }
    var onError: ((String) -> Void)? { get set }
    var onLoadingStatusChanged: ((Bool) -> Void)? { get set }
    func isFavorite(_ item: GiphyItem) -> Bool
    func toggleFavorite(for item: GiphyItem)
}

class BaseGiphyViewController<VM: BaseGiphyDelegate>: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var collectionView: UICollectionView
    let viewModel: VM
    
    var emptyStateView: EmptyStateView!
    var indicatorView: IndicatorView!
    var refreshControl: UIRefreshControl?
    var contentView = UIView()

    // MARK: - Init
    init(viewModel: VM) {
        self.viewModel = viewModel
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: SwiftyGiphyGridLayout())
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }

    // MARK: - Setup
    func setupViews() {
        view.backgroundColor = AppColors.background
        view.addSubview(contentView)
        contentView.anchorToFill(view: view)
        initIndicatorView()
        setupCollectionView()
        initShowEmptyStateView()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let collectionViewLayout = collectionView.collectionViewLayout as? SwiftyGiphyGridLayout
        {
            collectionViewLayout.delegate = self
        }
        
        registerCells()
        
        collectionView.backgroundColor = .clear
        contentView.addSubview(collectionView)
        collectionView.anchor(
            top: contentView.safeAreaLayoutGuide.topAnchor,
            leading: contentView.leadingAnchor,
            bottom: contentView.safeAreaLayoutGuide.bottomAnchor,
            trailing: contentView.trailingAnchor
        )
    }
    
    
    func registerCells() {
        collectionView.register(TrendingGiphyCollectionViewCell.self,
                                forCellWithReuseIdentifier: TrendingGiphyCollectionViewCell.reuseIdentifier)
    }
    
    func initShowEmptyStateView() {
        // Empty state view
        emptyStateView = EmptyStateView(message: TextConstants.nofavorites)
        contentView.addSubview(emptyStateView)
        emptyStateView.anchorToFill(view: contentView)
        emptyStateView.isHidden = true
    }
    
    func initIndicatorView() {
        indicatorView = IndicatorView()
        contentView.addSubview(indicatorView)
        indicatorView.anchorToFill(view: contentView)
    }
    
    func updateEmptyState() {
        let isEmpty = viewModel.items.isEmpty
        emptyStateView.isHidden = !isEmpty
        collectionView.isHidden = isEmpty
    }
    
    // MARK: - ViewModel
    func bindViewModel() {
        
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.refreshControl?.endRefreshing()
                self?.collectionView.reloadData()
                self?.updateEmptyState()
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
    
    @objc func favoriteTapped(_ sender: UIButton) {
        let item = viewModel.items[sender.tag]
        viewModel.toggleFavorite(for: item)
        NotificationCenter.default.post(name: .addToFavorite, object: nil,
                                        userInfo: ["item": item])
        if let cell = collectionView.cellForItem(at: IndexPath(item: sender.tag, section: 0)) as? TrendingGiphyCollectionViewCell {
            let isFavorite = viewModel.isFavorite(item)
            cell.favoriteButton.setTitle(isFavorite ? "★" : "☆", for: .normal)
        }
    }
    
    @objc func handleFavoriteStatusChanged(_ notification: Notification) {
        if let id = notification.userInfo?["id"] as? String,
           let index = viewModel.items.firstIndex(where: { $0.id == id }) {
            
            let item = viewModel.items[index]

            let indexPath = IndexPath(item: index, section: 0)
            if let cell = collectionView.cellForItem(at: indexPath) as? TrendingGiphyCollectionViewCell {
                let isFavorite = viewModel.isFavorite(item)
                cell.favoriteButton.setTitle(isFavorite ? "★" : "☆", for: .normal)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingGiphyCollectionViewCell.reuseIdentifier, for: indexPath) as? TrendingGiphyCollectionViewCell else {
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
        let detailsVC = DetailsGiphyViewController(item: item)
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

// MARK: - SwiftyGiphyGridLayoutDelegate
extension BaseGiphyViewController: SwiftyGiphyGridLayoutDelegate {

    public func collectionView(collectionView:UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, withWidth: CGFloat) -> CGFloat
    {
        guard viewModel.items.count > 0, let collectionViewLayout = collectionView.collectionViewLayout as? SwiftyGiphyGridLayout, let imageSet = viewModel.items[indexPath.row].imageSetClosestTo(width: collectionViewLayout.columnWidth) else {
            return 0.0
        }
        let titleHeight = (viewModel.items[indexPath.row].title?.heightWithConstrainedWidth(width: withWidth - 12 - 30, font: UIFont.boldSystemFont(ofSize: 14)) ?? 0.0)

        let descHeight = (viewModel.items[indexPath.row].title?.heightWithConstrainedWidth(width: withWidth - 8, font: UIFont.systemFont(ofSize: 12)) ?? 0.0)
        
        let height = descHeight + titleHeight + 14 + (imageSet.height?.cgFloatValue ?? 0.0)

        return AVMakeRect(aspectRatio: CGSize(width: imageSet.width!.cgFloatValue , height: height), insideRect: CGRect(x: 0.0, y: 0.0, width: withWidth, height: CGFloat.greatestFiniteMagnitude)).height
    }
}
