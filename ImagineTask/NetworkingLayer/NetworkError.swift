//
//  NetworkError.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingError
}
