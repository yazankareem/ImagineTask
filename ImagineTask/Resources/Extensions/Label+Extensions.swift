//
//  Label+Extensions.swift
//  ImagineTask
//
//  Created by Yazan on 04/12/2025.
//

import UIKit

extension UILabel {
    
    func setText(_ prefix: String, value: String?) {
        guard let value = value, !value.trimmingCharacters(in: .whitespaces).isEmpty else {
            self.isHidden = true
            return
        }
        
        let fullText = "\(prefix) \(value)"
        let attributedText = NSMutableAttributedString(string: fullText)
        
        // Bold prefix
        attributedText.addAttribute(.font,
                                    value: UIFont.boldSystemFont(ofSize: self.font.pointSize),
                                    range: NSRange(location: 0, length: prefix.count))
        
        // Normal value
        attributedText.addAttribute(.font,
                                    value: UIFont.systemFont(ofSize: self.font.pointSize),
                                    range: NSRange(location: prefix.count + 1, length: value.count))
        
        self.attributedText = attributedText
        self.isHidden = false
    }
}

