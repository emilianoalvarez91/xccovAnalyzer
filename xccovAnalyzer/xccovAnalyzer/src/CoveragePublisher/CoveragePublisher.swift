//
//  CoveragePublisher.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 31/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

class CoveragePublisher {

    static func publish(with githubPubliher: GithubReviewPublisher) {
        // Read diff report file
        let diffReportFileName = "diff_report.json"
        MessageWriter.write(message: "Reading \(diffReportFileName) file")
        let diffReportFileURL = Bundle.main.bundleURL.appendingPathComponent(diffReportFileName)
        guard FileManager.default.fileExists(atPath: diffReportFileURL.path),
            let coverageReport: CoverageReport = JsonCoder.decode(fileURL: diffReportFileURL) else {
                MessageWriter.write(message: "Missing \(diffReportFileName) file. Run first diff command.", .error)
                return
        }
        MessageWriter.write(message: "Success: Reading \(diffReportFileName) file", .success)

        // Format diff report as a github review
        MessageWriter.write(message: "Formatting diff report for github review")
        if let githubCoverageReport = GithubReviewFormatter.format(coverageReport: coverageReport) {
            MessageWriter.write(message: "Success: Formatting diff report for github review", .success)

            // Publish to github
            MessageWriter.write(message: "Publishing report to github")
            if let firstReview = githubPubliher.getCopyrightedReview() {
                let githubReview = GithubReviewPut(body: githubCoverageReport)
                let githubReviewJson = JsonCoder.encode(object: githubReview)
                githubPubliher.putReview(reviewId: firstReview.id, review: githubReviewJson)
            } else {
                let githubReview = GithubReviewPost(body: githubCoverageReport, event: GithubReviewEvent.COMMENT.rawValue)
                let githubReviewJson = JsonCoder.encode(object: githubReview)
                githubPubliher.post(review: githubReviewJson)
            }
            MessageWriter.write(message: "Success: Publishing report to github", .success)
        } else {
            MessageWriter.write(message: "No targets found for tests", .error)
        }
    }
}
