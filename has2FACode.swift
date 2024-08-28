//
//  has2FACode.swift
//  PolitiFilter
//
//  Created by Chase Robbins on 7/11/24.
//

import Foundation
func has2FACode(in text: String) -> Bool {
    // Define regular expressions for 2FA code formats
    let patterns = [
        "\\b\\d{6}\\b",           // XXXXXX
        "\\b\\d{3}-\\d{3}\\b",    // XXX-XXX
        "\\b\\d{3} \\d{3}\\b"     // XXX XXX
    ]
    
    for pattern in patterns {
        if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
            let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
            if !matches.isEmpty {
                return true
            }
        }
    }
    
    return false
}
