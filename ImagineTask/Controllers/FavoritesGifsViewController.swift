//
//  HomeViewController.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import UIKit
import AVFoundation

final class FavoritesGifsViewController: UIViewController {
    
    private var gifsCollectionView: UICollectionView!
    private let viewModel: FavoritesViewModel
    
    init(viewModel: FavoritesViewModel = FavoritesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindViewModel()
        addObserve()
        viewModel.loadFavorites()
    }
    
    private func initView() {
        view.backgroundColor = AppColors.background
        title = TextConstants.favoriteTitleText
        initCollectionView()
    }
    
    func addObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshItems(_:)), name: .addToFavorite, object: nil)
    }
    
    private func initCollectionView() {
        gifsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: SwiftyGiphyGridLayout())
        gifsCollectionView.delegate = self
        gifsCollectionView.dataSource = self
        
        if let collectionViewLayout = gifsCollectionView.collectionViewLayout as? SwiftyGiphyGridLayout
        {
            collectionViewLayout.delegate = self
        }
        
        gifsCollectionView.backgroundColor = .clear
        view.addSubview(gifsCollectionView)
        gifsCollectionView.anchorToFill(view: view)
        registerCells()
    }
    
    private func registerCells() {
        gifsCollectionView.register(TrendingGifsCollectionViewCell.self, forCellWithReuseIdentifier: TrendingGifsCollectionViewCell.reuseIdentifier)
        
        gifsCollectionView.register(FavoritesHeaderView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: FavoritesHeaderView.reuseIdentifier)
    }
    
    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.gifsCollectionView.reloadData()
            }
        }
    }
    
    @objc private func favoriteTapped(_ sender: UIButton) {
        let item = viewModel.items[sender.tag]
        viewModel.toggleFavorite(for: item)
        NotificationCenter.default.post(name: .favoriteStatusChanged, object: nil,
                                        userInfo: ["id": item.id])
    }
    
    @objc private func refreshItems(_ notification: Notification) {
        viewModel.loadFavorites()
    }

}

extension FavoritesGifsViewController: UICollectionViewDataSource {
    
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
            cell.configure(with: item, isFavorite: true, imageSet: imageSet)
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
}

// MARK: - SwiftyGiphyGridLayoutDelegate
extension FavoritesGifsViewController: SwiftyGiphyGridLayoutDelegate {

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

extension FavoritesGifsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            guard let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: FavoritesHeaderView.reuseIdentifier,
                for: indexPath) as? FavoritesHeaderView else {
                return UICollectionReusableView()
            }
            header.configure(count: viewModel.items.count)
            return header
        }
        return UICollectionReusableView()
    }
}
