//
//  TestAnalyzer.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 30/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

class TestAnalyzer {

    static func analyze(_ xcresultFilePath: String?) {
        // Read config yaml file
        let configYamlName = "xccovConfig.yml"

        let configYamlURL = Bundle.main.bundleURL.appendingPathComponent(configYamlName)
        guard FileManager.default.fileExists(atPath: configYamlURL.path) else {
          MessageWriter.write(message: "Missing \(configYamlURL.path) file", .error)
          return
        }
        MessageWriter.write(message: "Reading \(configYamlName) file")
        let config: Config = YamlDecoder.decode(configYamlURL)
        MessageWriter.write(message: "Success: Reading yaml file", .success)

        let testReportURL: URL
        if let xcresultFilePath = xcresultFilePath {
            testReportURL = URL(fileURLWithPath: xcresultFilePath)
        } else {
            // Find test report in derived data folder
            guard let projectRelativePath = config.projectRelativePath else {
                MessageWriter.write(message: "Missing project relative path in yml file.", .error)
                return
            }

            guard let derivedDataTestReportURL = TestFileLocator.locate(projectRelativePath: projectRelativePath) else {
                MessageWriter.write(message: "No test reports for the project. You need to run the test target first.", .error)
                return
            }
            testReportURL = derivedDataTestReportURL
        }

        // Read test report
        MessageWriter.write(message: "Reading test report")
        guard let testReportJson = TestFileJsonReader.read(fileUrl: testReportURL),
            !testReportJson.isEmpty else {
                MessageWriter.write(message: "Code coverage needs to be enabled before you run your tests.", .error)
                return
        }
        MessageWriter.write(message: "Success: Reading test report", .success)
        
        // Save original test report if no rules are set
        let testReportOutputName = "test_report.json"
        guard let filterRules = config.filterRules else {
            MessageWriter.write(message: "Saving original test report with name: \(testReportOutputName)")
            FileManager.default.write(string: testReportJson, fileName: testReportOutputName)
            MessageWriter.write(message: "Success: Saving original test report", .success)
            return
        }

        // Save filtered test report
        MessageWriter.write(message: "Saving filtered test report with name: \(testReportOutputName)")
        let testReport: TestReport = JsonCoder.decode(json: testReportJson)
        let filteredTestReport = TestReportFilter.filter(testReport, filterRules: filterRules)
        let filteredFileJson = JsonCoder.encode(object: filteredTestReport)
        FileManager.default.write(string: filteredFileJson, fileName: testReportOutputName)
        MessageWriter.write(message: "Success: Saving filtered test report", .success)
    }
}
