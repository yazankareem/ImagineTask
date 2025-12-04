//
//  FavoritesHeaderView.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import UIKit


final class FavoritesHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "FavoritesHeaderView"

    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = AppColors.text
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColors.secondaryBackground
        addSubview(countLabel)
        countLabel.anchor(leading: leadingAnchor, centerY: centerYAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
    }

    required init?(coder: NSCoder) { fatalError() }

    func configure(count: Int) {
        countLabel.text = "\(TextConstants.favoriteTitleText): \(count)"
    }
}
