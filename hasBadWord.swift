//
//  hasBadWord.swift
//  PolitiFilter
//
//  Created by Chase Robbins on 7/11/24.
//

import Foundation

private let keywords = [
    "vote",
    "trump",
    "biden",
    "donate",
    "poll",
    "survey",
    "state",
    "democrat",
    "republican",
    "election",
    "state",
    "free",
    "survey",
    "prize",
    "donation",
    "match",
    "%",
    "campaign",
    "candidate",
    "congress",
    "senate",
    "governor",
    "mayor",
    "credit",
    "mortgage",
    "payday",
    "interest",
    "sale",
    "discount",
    "MAGA",
    "fundraising",
    "voucher",
    "discount",
    "$",
    "dnc",
    "rnc",
    "gop",
    "voucher",
    "LLC",
    "inc",
    ".us",
    "survey",
    "kamala",
    "debt",
    "loan",
    "collect",
    "negotiate",
    "balance",
    "pay",
    "midweekpay",
    ".club",
    "stop",
    "loyalty",
    "redeem",
    "recruit",
    "WhatsApp"
]
func hasBadWord(message: String) -> Bool {
    // Retrieve the custom blacklist from UserDefaults
    let userDefaults = UserDefaults(suiteName: "group.com.chrv.filtergroup")
    let customKeywords = userDefaults?.stringArray(forKey: "blackList") ?? []

    // Combine the default keywords and custom keywords
    let combinedKeywords = keywords + customKeywords

    // Check if the message body contains any of the keywords
    let messageBody = message.lowercased()
    for keyword in combinedKeywords {
        if messageBody.contains(keyword) {
            log(content: "Keyword detected in message: \(keyword)")
            return true
        }
    }
    return false
}
