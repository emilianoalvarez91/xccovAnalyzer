//
//  TestReportDiff.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 30/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

class TestReportComparator {

    static func compareTestReports(_ testReport: TestReport, historyTestReport: TestReport?) -> CoverageReport {
       var coverageTargets = Set<CoverageTarget>()
        for testTarget in testReport.targets {
            let historyTestTarget = historyTestReport?.targets.first(where: { $0.name == testTarget.name })

            var coverageFiles = Set<CoverageFile>()
            // Add files only if there's a history test report to avoid pushing all the project's files at once
            if historyTestReport != nil {
                for testFile in testTarget.files {
                    let historyTestFile = historyTestTarget?.files.first(where: { $0.name == testFile.name })

                    // Don't include files that were not modified
                    if let historyTestFile = historyTestFile,
                        testFile.lineCoverage == historyTestFile.lineCoverage,
                        testFile.coveredLines == historyTestFile.coveredLines,
                        testFile.executableLines == historyTestFile.executableLines {
                        continue
                    }

                    let currentTestFileCoverage = testFile.lineCoverage * 100
                    let historyTestFileCovarage = (historyTestFile?.lineCoverage ?? 0.0) * 100

                    let coverageFile = CoverageFile(
                        name: testFile.name,
                        currentCoverage: currentTestFileCoverage,
                        previousCoverage: historyTestFileCovarage,
                        coverageDifference: currentTestFileCoverage - historyTestFileCovarage
                    )
                    coverageFiles.insert(coverageFile)
                }
            }

            let currentTargetCoverage = testTarget.lineCoverage * 100
            let historyTargetCoverage = (historyTestTarget?.lineCoverage ?? 0.0) * 100
            let coverageTarget = CoverageTarget(
                name: testTarget.name,
                currentCoverage: currentTargetCoverage,
                previousCoverage: historyTargetCoverage,
                coverageDifference: currentTargetCoverage - historyTargetCoverage,
                files: !coverageFiles.isEmpty ? coverageFiles : nil
            )
            coverageTargets.insert(coverageTarget)
        }

        return CoverageReport(targets: coverageTargets)
    }
}
