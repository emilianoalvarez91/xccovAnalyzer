//
//  GithubReviewFormatter.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 30/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

class GithubReviewFormatter {

    private static let thumbsUpEmoji = ":+1:"
    private static let thumbsDownEmoji = ":-1:"
    private static let fearfulEmoji = ":fearful:"
    private static let metalEmoji = ":metal:"
    private static let okEmoji = ":ok_hand:"

    static func format(coverageReport: CoverageReport) -> String? {
        guard !coverageReport.targets.isEmpty else {
            return nil
        }

        var commentReport = "### Targets coverage\n"
        commentReport += "|Target|Current %|Previous %|Coverage Δ|\n"
        commentReport += "|---|---:|---:|---:|\n"
        for target in coverageReport.targets {
            commentReport += addReport(
                name: target.name,
                currentCoverage: target.currentCoverage,
                previousCoverage: target.previousCoverage,
                coverageDifference: target.coverageDifference
            )
        }

        for target in coverageReport.targets {
            guard let files = target.files,
                !files.isEmpty else {
                    continue
            }
            commentReport += "\n### \(target.name) files coverage\n"
            commentReport += "|File|Current %| Previous %| Coverage Δ |\n"
            commentReport += "|---|---:|---:|---:|\n"

            let sortedFiles = files.sorted(by: { (file1, file2) -> Bool in
                file1.coverageDifference < file2.coverageDifference
            })
            for file in sortedFiles {
                commentReport += addReport(
                    name: file.name,
                    currentCoverage: file.currentCoverage,
                    previousCoverage: file.previousCoverage,
                    coverageDifference: file.coverageDifference
                )
            }
        }

        commentReport += "\n\(Constants.copyright)"

        return commentReport
    }

    private static func addReport(name: String, currentCoverage: Double, previousCoverage: Double, coverageDifference: Double) -> String {
        let currentCoverageFormatted = "\(formatDecimal(currentCoverage))%"
        let previousCoverageFormatted = "\(formatDecimal(previousCoverage))%"
        let coverageDifferenceFormatted = formatCoverageDifference(currentCoverage: currentCoverage, previousCoverage: previousCoverage, coverageDifference: coverageDifference)
        return "|\(name)|\(currentCoverageFormatted)|\(previousCoverageFormatted)|\(coverageDifferenceFormatted)|\n"
    }

    private static func formatCoverageDifference(currentCoverage: Double, previousCoverage: Double, coverageDifference: Double) -> String {
        let coverageDifferenceFormatted = formatDecimal(coverageDifference)
        if currentCoverage == 0 {
            return "**\(coverageDifferenceFormatted)% \(fearfulEmoji)**"
        }

        if coverageDifference < 0 {
            return "**\(coverageDifferenceFormatted)% \(thumbsDownEmoji)**"
        }

        if currentCoverage == 100 {
            return "\(coverageDifferenceFormatted)% \(metalEmoji)"
        }

        if currentCoverage == previousCoverage {
            return "\(coverageDifferenceFormatted)% \(okEmoji)"
        }

        return "\(coverageDifferenceFormatted)% \(thumbsUpEmoji)"
    }

    private static func formatDecimal(_ decimal: Double) -> String {
        return String(format: "%.2f", decimal)
    }
}
