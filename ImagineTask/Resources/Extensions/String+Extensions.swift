//
//  String+Extensions.swift
//  ImagineTask
//
//  Created by Yazan on 03/12/2025.
//

import Foundation

extension String {
    var asURL: URL? {
        return URL(string: self)
    }
}
