//
//  Endpoint.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import Foundation

enum Endpoint {
    
    case trending(offset: Int)
    case search(query: String, offset: Int)
    
    var url: URL? {
        switch self {
        case .trending(let offset):
            return URL(string:
                "\(Constants.baseURL)/gifs/trending?api_key=\(Constants.apiKey)&limit=\(Constants.itemsPerPage)&offset=\(offset)"
            )
        case .search(let query, let offset):
            let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            return URL(string:
                "\(Constants.baseURL)/gifs/search?api_key=\(Constants.apiKey)&q=\(encoded)&limit=\(Constants.itemsPerPage)&offset=\(offset)"
            )
        }
    }
}
