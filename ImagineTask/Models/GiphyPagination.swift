//
//  GiphyPagination.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import Foundation

struct GiphyPagination: Codable {
    let totalCount: Int
    let count: Int
    let offset: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count
        case offset
    }
}
