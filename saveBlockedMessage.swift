//
//  saveBlockedMessage.swift
//  PolitiFilter
//
//  Created by Chase Robbins on 7/11/24.
//

import Foundation
import IdentityLookup

func saveBlockedMessage(queryRequest: ILMessageFilterQueryRequest, blockedReason: String, detectedKeyword: String? = nil) {
    
    log(content: "Attempting to save blocked message locally")

    guard let fileURL = getBlockedMessagesFilePath() else {
        log(content: "Failed to get file URL")
        return
    }
    
    log(content: "Got the file URL: \(fileURL)")

    let blockedMessage: [String: String] = [
        "messageContent": queryRequest.messageBody ?? "",
        "messageSenderNumber": queryRequest.sender ?? "",
        "blockedReason": blockedReason,
        "detectedKeyword": detectedKeyword ?? ""
    ]

    var blockedMessages: [[String: String]] = []

    if let data = try? Data(contentsOf: fileURL),
       let existingMessages = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: String]]
    {
        blockedMessages = existingMessages
        log(content: "Fetched existing messages. Current count: \(blockedMessages.count)")
    } else {
        log(content: "No existing messages found or failed to fetch existing messages.")
    }

    blockedMessages.append(blockedMessage)
    log(content: "Added new blocked message. New count: \(blockedMessages.count)")

    log(content: "Attempting to write the data to the file")

    if let jsonData = try? JSONSerialization.data(withJSONObject: blockedMessages, options: []) {
        do {
            try jsonData.write(to: fileURL)
            log(content: "Successfully wrote data to the file")
        } catch {
            log(content: "Failed to write data to the file: \(error.localizedDescription)")
        }
    } else {
        log(content: "Failed to serialize blocked messages to JSON")
    }
    
    log(content: "Completed data writing")
}

private func getBlockedMessagesFilePath() -> URL? {
    log(content: "Getting file path to blocked messages JSON")
    let fileManager = FileManager.default
    guard let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.chrv.filtergroup") else {
        log(content: "Couldn't get the directory")
        return nil
    }
    return directory.appendingPathComponent("blockedMessages.json")
}
