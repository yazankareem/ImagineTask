//
//  MainTabBarController.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//


import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.barTintColor = .white
        
        tabBar.tintColor = UIColor(named: Colors.purple.rawValue)
        
        tabBar.unselectedItemTintColor = UIColor(named: Colors.lightPurple.rawValue)

    }
}
