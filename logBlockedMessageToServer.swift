//
//  logBlockedMessageToServer.swift
//  PolitiFilter
//
//  Created by Chase Robbins on 7/11/24.
//

import Foundation

func logBlockedMessageToServer(from: String, content: String) {
    log(content: "Attempting to log message to the server")
    guard let url = URL(string: "https://trackspam-gn25igod2a-uc.a.run.app") else {
        print("Invalid URL")
        log(content: "Invalid URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let requestBody: [String: String] = ["from": from, "content": content]

    guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: []) else {
        print("Failed to serialize JSON")
        log(content: "Failed to serialize JSON")
        return
    }

    request.httpBody = jsonData

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Failed to log blocked message: \(error)")
            log(content: "Failed to log blocked message: \(error)")
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, (200 ... 299).contains(httpResponse.statusCode) else {
            print("Server error")
            log(content: "Server error")
            return
        }

        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            print("Server response: \(responseString)")
            log(content: "Server response: \(responseString)")
        }
    }

    task.resume()
}
