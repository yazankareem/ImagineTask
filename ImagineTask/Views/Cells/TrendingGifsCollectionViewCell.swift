//
//  TrendingGifsCollectionViewCell.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import UIKit
import SDWebImage

final class TrendingGifsCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "TrendingGifsCollectionViewCell"
    
    private let gifImageView: SDAnimatedImageView = {
        let iv = SDAnimatedImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = AppColors.text
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = AppColors.text
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let favoriteButton: UIButton = {
        let button = UIButton()
        button.setTitle("☆", for: .normal)
        button.setTitleColor(.systemYellow, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24)
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = AppColors.secondaryBackground
        contentView.layer.cornerRadius = 8
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        gifImageView.sd_cancelCurrentImageLoad()
        gifImageView.image = nil
        favoriteButton.setTitle("☆", for: .normal)
        descriptionLabel.text = nil
        titleLabel.text = nil
    }
    
    // MARK: - Layout
    private func setupLayout() {
        [gifImageView, titleLabel, descriptionLabel, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        gifImageView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor)
        gifImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        titleLabel.anchor(top: gifImageView.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, padding: UIEdgeInsets(top: 4, left: 4, bottom: 0, right: -4))
        
        favoriteButton.anchor(bottom: nil, trailing: contentView.trailingAnchor, centerY: titleLabel.centerYAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -4), size: CGSize(width: 30, height: 30))
        
        titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: -4).isActive = true
        titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true

        descriptionLabel.anchor(top: titleLabel.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 2, left: 4, bottom: -4, right: -4))
                
        descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    // MARK: - Configure
    func configure(with item: GiphyItem, isFavorite: Bool) {
        titleLabel.text = item.title
        descriptionLabel.text = item.title
        if let url = item.images.original?.url?.asURL {
            gifImageView.sd_setImage(with: url)
        }
        favoriteButton.setTitle(isFavorite ? "★" : "☆", for: .normal)
    }
}
