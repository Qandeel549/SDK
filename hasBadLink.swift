//
//  hasBadLink.swift
//  PolitiFilter
//
//  Created by Chase Robbins on 7/11/24.
//

import Foundation

func hasBadLink(message: String) -> Bool {
    let messageBody = message
    let regex = try! NSRegularExpression(pattern: "https?://[^\\s]+")
    let matches = regex.matches(in: messageBody, range: NSRange(messageBody.startIndex..., in: messageBody))
    for match in matches {
        if let range = Range(match.range, in: messageBody) {
            let url = String(messageBody[range]) // Convert Substring to String
            if !url.contains(".com") && !url.contains(".gov") && !url.contains(".org") {
                log(content: "Sus link found")
                
                return true
            }
        }
    }
    return false
}
