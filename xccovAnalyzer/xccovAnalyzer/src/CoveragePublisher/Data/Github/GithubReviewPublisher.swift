//
//  GithubReviewPublisher.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 31/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

class GithubReviewPublisher {

    private let githubBaseUrl = "https://api.github.com"
    private let curlScript = "curl %@"

    private let owner: String
    private let repo: String
    private let pullNumber: String
    private let username: String
    private let personalAccessToken: String

    init(
        owner: String,
        repo: String,
        pullNumber: String,
        username: String,
        personalAccessToken: String
    ) {
        self.owner = owner
        self.repo = repo
        self.pullNumber = pullNumber
        self.username = username
        self.personalAccessToken = personalAccessToken
    }

    private var pathURL: String {
        return "\(githubBaseUrl)/repos/\(owner)/\(repo)/pulls/\(pullNumber)/reviews"
    }

    private var auth: String {
        return "-u \(username):\(personalAccessToken)"
    }

    func getCopyrightedReview() -> GithubReview? {
        let curlString = "\(auth) \(pathURL)"
        let result = ShellScriptRunnable.run(String(format: curlScript, curlString))

        if var result = result {
            result = result.replacingOccurrences(of: "\\", with: "")
            result = result.replacingOccurrences(of: "\n", with: "")
            let reviews: [GithubReview] = JsonCoder.decode(json: result)
            return reviews.first { $0.body.contains(Constants.copyright) }
        }
        return nil
    }

    func post(review: String) {
        let method = "-X POST"
        let curlString = "\(auth) \(method) \(pathURL) \(addJsonBody(review))"
        ShellScriptRunnable.run(String(format: curlScript, curlString))
    }

    func putReview(reviewId: Int, review: String) {
        let method = "-X PUT"
        let curlString = "\(auth) \(method) \(pathURL)/\(reviewId) \(addJsonBody(review))"
        ShellScriptRunnable.run(String(format: curlScript, curlString))
    }

    private func addJsonBody(_ body: String) -> String {
        return "-d '\(body)'"
    }
}
