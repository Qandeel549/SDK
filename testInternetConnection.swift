//
//  testInternetConnection.swift
//  PolitiFilter
//
//  Created by Chase Robbins on 7/11/24.
//

import Foundation
func testInternetConnection() {
    guard let url = URL(string: "https://www.google.com") else {
        let errorMessage = "Invalid URL"
        print(errorMessage)
        log(content: errorMessage)
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            let errorMessage = "Failed to reach the internet: \(error.localizedDescription)"
            print(errorMessage)
            log(content: errorMessage)
            return
        }

        guard let httpResponse = response as? HTTPURLResponse, (200 ... 299).contains(httpResponse.statusCode) else {
            let errorMessage = "Internet test failed: Server error"
            print(errorMessage)
            log(content: errorMessage)
            return
        }

        let successMessage = "Successfully reached the internet"
        print(successMessage)
        log(content: successMessage)
    }

    task.resume()
}
