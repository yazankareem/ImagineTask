//
//  GiphyItem.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import Foundation

import Foundation

struct GiphyItem: Codable, Equatable {
    let id: String
    let url: String
    let title: String
    let images: GiphyImages
    let slug: String
    let type: String

    // MARK: - Equatable
    static func == (lhs: GiphyItem, rhs: GiphyItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    enum CodingKeys: CodingKey {
        case id
        case url
        case title
        case images
        case type
        case slug
    }
}

