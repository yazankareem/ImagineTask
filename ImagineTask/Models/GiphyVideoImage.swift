//
//  GiphyVideoImage.swift
//  ImagineTask
//
//  Created by Yazan on 06/12/2025.
//


struct GiphyVideoImage: Codable {
    let height: String?
    let width: String?

    enum CodingKeys: String, CodingKey {
        case height, width
    }
}