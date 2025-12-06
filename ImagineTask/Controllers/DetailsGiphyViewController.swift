//
//  DetailsGiphyViewController.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import UIKit
import SDWebImage

final class DetailsGiphyViewController: UIViewController {

    private let viewModel: DetailsGiphyViewModel

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let stackView = UIStackView()
    private var favoritesButton: UIBarButtonItem!
    private var imageHeightConstraint: NSLayoutConstraint?

    private let imageView: SDAnimatedImageView = {
        let iv = SDAnimatedImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        return iv
    }()

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let urlLabel = UILabel()
    private let typeLabel = UILabel()
    private let slugLabel = UILabel()

    // MARK: - Init
    init(item: GiphyItem) {
        self.viewModel = DetailsGiphyViewModel(item: item)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        setupUI()
        configureView()
        bindViewModel()
    }

    // MARK: - UI Setup
    private func setupUI() {
        setupFavoritesButton()
        setupScrollView()
        setupStackView()
        setupLabels()
    }

    private func setupFavoritesButton() {
        favoritesButton = UIBarButtonItem(
            image: UIImage(systemName: "star")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(favoriteTapped)
        )
        navigationItem.rightBarButtonItem = favoritesButton
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          bottom: view.bottomAnchor,
                          trailing: view.trailingAnchor)
        contentView.anchor(top: scrollView.topAnchor,
                           leading: scrollView.leadingAnchor,
                           bottom: scrollView.bottomAnchor,
                           trailing: scrollView.trailingAnchor)
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 16
        contentView.addSubview(stackView)
        stackView.anchor(top: contentView.topAnchor,
                         leading: contentView.leadingAnchor,
                         bottom: contentView.bottomAnchor,
                         trailing: contentView.trailingAnchor,
                         padding: UIEdgeInsets(top: 16, left: 16, bottom: -16, right: -16))
        
        // Add arranged subviews
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(urlLabel)
        stackView.addArrangedSubview(typeLabel)
        stackView.addArrangedSubview(slugLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: 200) // default placeholder
        imageHeightConstraint?.isActive = true
    }

    private func setupLabels() {
        [titleLabel, descriptionLabel, urlLabel, typeLabel, slugLabel].forEach {
            $0.numberOfLines = 0
            $0.textColor = AppColors.text
            $0.font = .systemFont(ofSize: 16)
        }
        titleLabel.font = .boldSystemFont(ofSize: 22)
        urlLabel.textColor = AppColors.accent
    }

    // MARK: - Configure
    private func configureView() {
        let item = viewModel.item

        setLabel(titleLabel, preFix: nil, text: item.title)
        setLabel(descriptionLabel, preFix: nil, text: item.title)
        setLabel(urlLabel, preFix: "URL:", text: item.url?.absoluteString)
        setLabel(typeLabel, preFix: "Type:", text: item.type)
        setLabel(slugLabel, preFix: "Slug:", text: item.slug)

        if let url = item.images.original?.url {
            imageView.sd_setImage(with: url) { [weak self] image, _, _, _ in
                guard let self = self, let image = image else { return }
                let aspectRatio = image.size.height / image.size.width
                let width = self.view.frame.width - 32 // 16 padding each side
                let height = width * aspectRatio
                self.imageHeightConstraint?.constant = height
                self.view.layoutIfNeeded()
            }
        }
        updateFavoriteButton()
    }

    private func setLabel(_ label: UILabel, preFix: String?, text: String?) {
        if let text = text, !text.trimmingCharacters(in: .whitespaces).isEmpty {
            label.setText(preFix ?? "", value: text)
            label.isHidden = false
        } else {
            label.text = nil
            label.isHidden = true
        }
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            DispatchQueue.main.async { self?.updateFavoriteButton() }
        }
    }

    // MARK: - Favorite
    @objc private func favoriteTapped() {
        viewModel.toggleFavorite()
        updateFavoriteButton()
        NotificationCenter.default.post(name: .favoriteStatusChanged, object: nil,
                                        userInfo: ["id": viewModel.item.id])
        NotificationCenter.default.post(name: .addToFavorite, object: nil,
                                        userInfo: ["item": viewModel.item])
    }

    private func updateFavoriteButton() {
        let imageName = viewModel.isFavorite() ? "star.fill" : "star"
        favoritesButton.image = UIImage(systemName: imageName)?.withRenderingMode(.alwaysOriginal)
    }
}
