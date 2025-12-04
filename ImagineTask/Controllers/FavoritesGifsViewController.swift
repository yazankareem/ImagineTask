import UIKit

final class FavoritesGifsViewController: UIViewController {
    
    private var gifsCollectionView: SelfSizingCollectionView!
    private let viewModel: FavoritesViewModel
    
    init(viewModel: FavoritesViewModel = FavoritesViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // MARK: viewModel.fetchTrending() Call here to refresh data when switch between tabBar to update favorite items
        viewModel.loadFavorites()
    }
    
    private func initView() {
        view.backgroundColor = AppColors.background
        title = TextConstants.favoriteTitleText
        initCollectionView()
    }
    
    private func initCollectionView() {
        gifsCollectionView = SelfSizingCollectionView()
        gifsCollectionView.delegate = self
        gifsCollectionView.dataSource = self
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
        cell.configure(with: item, isFavorite: true)
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
