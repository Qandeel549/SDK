//
//  countMessage.swift
//  PolitiFilter
//
//  Created by Chase Robbins on 7/11/24.
//

import Foundation

func countMessage() {
    log(content: "Attempting to count the message.")
    if let userDefaults = UserDefaults(suiteName: "group.com.chrv.filtergroup") {
        log(content: "Count Message user Defaults are initialized.")
        let currentCount = userDefaults.integer(forKey: "messagesBlocked")
        log(content: "Current blocked message count IS: \(currentCount)")
        userDefaults.set(currentCount + 1, forKey: "messagesBlocked")
        log(content: "Setting the count to \(currentCount + 1)")
        log(content: "New blocked message count is: \(userDefaults.integer(forKey: "messagesBlocked"))")

    }
}
