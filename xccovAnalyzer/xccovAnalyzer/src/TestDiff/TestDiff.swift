//
//  TestDiff.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 30/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

class TestDiff {

    static func diff() {
        // Read test report file
        let testReportFileName = "test_report.json"
        MessageWriter.write(message: "Reading \(testReportFileName) file")
        let testReportFileURL = Bundle.main.bundleURL.appendingPathComponent(testReportFileName)
        guard FileManager.default.fileExists(atPath: testReportFileURL.path),
            let testReport: TestReport = JsonCoder.decode(fileURL: testReportFileURL) else {
                MessageWriter.write(message: "Missing \(testReportFileName) file. Run first analyze command.", .error)
                return
        }
        MessageWriter.write(message: "Success: Reading \(testReportFileName) file", .success)

        // Read test report history file
        let historyReportFileName = "history_test_report.json"
        MessageWriter.write(message: "Reading \(historyReportFileName) file")
        let historyTestReportFileURL = Bundle.main.bundleURL.appendingPathComponent(historyReportFileName)
        let historyTestReport: TestReport?
        if FileManager.default.fileExists(atPath: historyTestReportFileURL.path) {
            historyTestReport = JsonCoder.decode(fileURL: historyTestReportFileURL)
            MessageWriter.write(message: "Success: Reading \(historyReportFileName) file", .success)
        } else {
            historyTestReport = nil
            MessageWriter.write(message: "Warning: No history test report file", .warning)
        }

        // Generating test coverage report
        MessageWriter.write(message: "Generating CoverageReport")
        let coverageReport = TestReportComparator.compareTestReports(testReport, historyTestReport: historyTestReport)
        MessageWriter.write(message: "Success: Generating CoverageReport", .success)

        // Save diff report
        let coverageDiffOutputName = "diff_report.json"
        MessageWriter.write(message: "Saving test coverage report with name: \(coverageDiffOutputName)")
        let coverageReportJson = JsonCoder.encode(object: coverageReport)
        FileManager.default.write(string: coverageReportJson, fileName: coverageDiffOutputName)
        MessageWriter.write(message: "Success: Saving filtered test report", .success)
    }
}
