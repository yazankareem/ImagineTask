//
//  FirstLaunchAlert.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import UIKit

class FirstLaunchAlert {

    private static let key = "didLaunchBefore"

    static func showIfNeeded(on vc: UIViewController) {
        let launchedBefore = UserDefaults.standard.bool(forKey: key)

        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: key)

            let alert = UIAlertController(
                title: "Welcome!",
                message: "Thank you for using ImaginTask!",
                preferredStyle: .alert
            )

            alert.addAction(UIAlertAction(title: "OK", style: .default))
            vc.present(alert, animated: true)
        }
    }
}
