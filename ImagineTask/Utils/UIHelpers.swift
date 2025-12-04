//
//  UIHelpers.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import UIKit

enum UIHelpers {
    static func createLabel(
        text: String? = nil,
        font: UIFont = .systemFont(ofSize: 16),
        color: UIColor = AppColors.text,
        lines: Int = 1
    ) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.numberOfLines = lines
        return label
    }
}
