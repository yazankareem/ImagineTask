//
//  Notificationcenter+Extensions.swift
//  ImagineTask
//
//  Created by Yazan on 06/12/2025.
//

import UIKit
import Foundation

enum NotificationCenterKey: String {
    case favoriteStatusChanged = "favoriteStatusChanged"
    case addToFavorite = "addToFavorite"
}
extension Notification.Name {
    static let favoriteStatusChanged = Notification.Name(NotificationCenterKey.favoriteStatusChanged.rawValue)
    static let addToFavorite = Notification.Name(NotificationCenterKey.addToFavorite.rawValue)
}
