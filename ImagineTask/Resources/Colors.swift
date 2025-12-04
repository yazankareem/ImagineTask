//
//  Colors.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import UIKit

enum Colors: String {
    case purple = "purple"
    case lightPurple = "lightPurple"
}

enum AppColors {
    static let background = UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor.black : UIColor.white
    }

    static let secondaryBackground = UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor.darkGray : UIColor.systemGray6
    }

    static let text = UIColor(named: Colors.purple.rawValue) ?? .tintColor
    
    static let accent = UIColor.systemBlue
}
