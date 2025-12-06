//
//  GiphyItem.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import Foundation

struct GiphyItem: Codable, Equatable {
    let type: String
    let id: String
    let url: URL?
    let slug: String?
    let bitlyGifURL: URL?
    let bitlyURL: URL?
    let embedURL: URL?
    let username: String?
    let source: String?
    let title: String?
    let rating: String?
    let contentURL: String?
    let sourceTLD: String?
    let sourcePostURL: String?
    let isSticker: Int?
    let importDatetime: String?
    let trendingDatetime: String?
    let images: GiphyImageFormats
    let analyticsResponsePayload: String?
    let altText: String?
    let isLowContrast: Bool?
    
    static func == (lhs: GiphyItem, rhs: GiphyItem) -> Bool {
        return lhs.id == rhs.id
    }

    enum CodingKeys: String, CodingKey {
        case type, id, url, slug
        case bitlyGifURL = "bitly_gif_url"
        case bitlyURL = "bitly_url"
        case embedURL = "embed_url"
        case username, source, title, rating
        case contentURL = "content_url"
        case sourceTLD = "source_tld"
        case sourcePostURL = "source_post_url"
        case isSticker = "is_sticker"
        case importDatetime = "import_datetime"
        case trendingDatetime = "trending_datetime"
        case images
        case analyticsResponsePayload = "analytics_response_payload"
        case altText = "alt_text"
        case isLowContrast = "is_low_contrast"
    }
    
    public func imageSetClosestTo(width: CGFloat) -> GiphyImage? {
        
        var imageSetsForConsideration = [GiphyImage]()
        
        if let fixedHeight = images.fixedHeight {
                imageSetsForConsideration.append(fixedHeight)
        }
        
        if let fixedHeightDownsampled = images.fixedHeightDownsampled {
                imageSetsForConsideration.append(fixedHeightDownsampled)
        }
        
        if images.fixedWidth != nil {
                imageSetsForConsideration.append(images.fixedWidth!)
        }
        
        if let fixedWidthDownsampled = images.fixedWidthDownsampled {
                imageSetsForConsideration.append(fixedWidthDownsampled)
        }
        
        if let fixedHeightSmall = images.fixedHeightSmall {
            imageSetsForConsideration.append(fixedHeightSmall)
        }
        
        if let fixedWidthSmall = images.fixedWidthSmall {
            imageSetsForConsideration.append(fixedWidthSmall)
        }
        
        if let downsized = images.downsized {
            imageSetsForConsideration.append(downsized)
        }
        
        if let downsizedLarge = images.downsizedLarge {
            imageSetsForConsideration.append(downsizedLarge)
        }
        
        if let original = images.original {
            imageSetsForConsideration.append(original)
        }
        
        // Search for matches
        
        guard imageSetsForConsideration.count > 0 else {
            return nil
        }
        
        var currentClosestSizeMatch: GiphyImage = imageSetsForConsideration[0]
        
        for item in imageSetsForConsideration {
            if item.width!.cgFloatValue >= width && item.width!.cgFloatValue < currentClosestSizeMatch.width!.cgFloatValue {
                currentClosestSizeMatch = item
            }
        }
        
        return currentClosestSizeMatch
    }
}
