//
//  GiphyResponse.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import Foundation

struct GiphyResponse: Codable {
    let data: [GiphyItem]
    let pagination: GiphyPagination
    
    enum CodingKeys: CodingKey {
        case data
        case pagination
    }
}
