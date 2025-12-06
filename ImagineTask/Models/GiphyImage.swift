//
//  GiphyImage.swift
//  ImagineTask
//
//  Created by Yazan on 06/12/2025.
//

import Foundation

struct GiphyImage: Codable {
    let height: String?
    let width: String?
    let url: URL?
    let size: String?

    enum CodingKeys: String, CodingKey {
        case height, width, url, size
    }
}
