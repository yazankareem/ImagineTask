//
//  Navigation+Extensions.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import UIKit

extension UINavigationController {

    func applyPurpleNavigationBar() {
        let purpleColor = UIColor(named: Colors.purple.rawValue)
        
        // Background color
        navigationBar.barTintColor = .white
        
        // Title color
        navigationBar.titleTextAttributes = [
            .foregroundColor: purpleColor,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        // Back button and bar button items color
        navigationBar.tintColor = purpleColor
    }
}
