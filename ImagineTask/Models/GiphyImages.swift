//
//  GiphyImages.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import Foundation

struct GiphyImages: Codable {
    let original: GiphyImageFormat?

    enum CodingKeys: String, CodingKey {
        case original
    }
}
