//
//  LoaderView.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//


import UIKit

final class IndicatorView: UIView {

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator: UIActivityIndicatorView
        if #available(iOS 13.0, *) {
            indicator = UIActivityIndicatorView(style: .large)
        } else {
            indicator = UIActivityIndicatorView(style: .whiteLarge)
        }
        indicator.color = UIColor(named: Colors.purple.rawValue)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(named: Colors.lightPurple.rawValue)?.withAlphaComponent(0.3)
        alpha = 0
        setupIndicator()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupIndicator() {
        addSubview(activityIndicator)
        activityIndicator.anchor(centerX: centerXAnchor, centerY: centerYAnchor)
    }

    func show() {
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.25) { self.alpha = 1 }
    }

    func hide() {
        UIView.animate(withDuration: 0.25, animations: { self.alpha = 0 }) { _ in
            self.activityIndicator.stopAnimating()
        }
    }
}
