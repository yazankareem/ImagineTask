//
//  GiphyImageFormats.swift
//  ImagineTask
//
//  Created by Yazan on 06/12/2025.
//

import Foundation

struct GiphyImageFormats: Codable {
    let original: GiphyImage?
    let downsized: GiphyImage?
    let downsizedLarge: GiphyImage?
    let downsizedMedium: GiphyImage?
    let downsizedSmall: GiphyVideoImage?
    let downsizedStill: GiphyImage?

    let fixedHeight: GiphyImage?
    let fixedHeightDownsampled: GiphyImage?
    let fixedHeightSmall: GiphyImage?
    let fixedHeightSmallStill: GiphyImage?
    let fixedHeightStill: GiphyImage?

    let fixedWidth: GiphyImage?
    let fixedWidthDownsampled: GiphyImage?
    let fixedWidthSmall: GiphyImage?
    let fixedWidthSmallStill: GiphyImage?
    let fixedWidthStill: GiphyImage?
    let originalStill: GiphyImage?

    enum CodingKeys: String, CodingKey {
        case original
        case downsized
        case downsizedLarge = "downsized_large"
        case downsizedMedium = "downsized_medium"
        case downsizedSmall = "downsized_small"
        case downsizedStill = "downsized_still"

        case fixedHeight = "fixed_height"
        case fixedHeightDownsampled = "fixed_height_downsampled"
        case fixedHeightSmall = "fixed_height_small"
        case fixedHeightSmallStill = "fixed_height_small_still"
        case fixedHeightStill = "fixed_height_still"

        case fixedWidth = "fixed_width"
        case fixedWidthDownsampled = "fixed_width_downsampled"
        case fixedWidthSmall = "fixed_width_small"
        case fixedWidthSmallStill = "fixed_width_small_still"
        case fixedWidthStill = "fixed_width_still"
        case originalStill = "original_still"
    }
}
