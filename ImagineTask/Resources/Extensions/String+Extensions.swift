//
//  String+Extensions.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import Foundation
import UIKit

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        return ceil(boundingBox.height)
    }
}

extension String {
    var cgFloatValue: CGFloat {
        return CGFloat(Double(self) ?? 0)
    }
}
