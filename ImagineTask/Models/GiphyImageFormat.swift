//
//  GiphyImageFormat.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import Foundation

struct GiphyImageFormat: Codable {
    let url: String?
    let width: String?
    let height: String?
    
    enum CodingKeys: CodingKey {
        case url
        case width
        case height
    }
}
