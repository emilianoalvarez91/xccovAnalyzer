//
//  TestReportFilter.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 16/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

class TestReportFilter {

    static func filter(_ testReport: TestReport, filterRules: [FilterRule]) -> TestReport {
        guard !filterRules.isEmpty else {
            return testReport
        }

        var mTestReport = testReport
        mTestReport.targets = filterTargets(in: testReport, with: filterRules)
        recalculateTestReportLines(&mTestReport)
        return mTestReport
    }

    private static func filterTargets(in testReport: TestReport, with filterRules: [FilterRule]) -> [TestTarget] {
        var filteredTargets = [TestTarget]()
        for target in testReport.targets {

            let targetFilterMatchingRules = filterRules.filter { $0.targetName == target.name }

            for targetFilterRule in targetFilterMatchingRules {
                var mTarget = target
                var mFiles = mTarget.files
                if let displayName = targetFilterRule.displayName {
                    mTarget.name = displayName
                }

                filterOnPaths(files: &mFiles, with: targetFilterRule)
                filterOnFilesNames(files: &mFiles, with: targetFilterRule)
                filterOnFunctionsNames(files: &mFiles, with: targetFilterRule)

                mTarget.files = mFiles
                recalculateTestTargetLines(&mTarget)
                filteredTargets.append(mTarget)
            }
        }
        return filteredTargets
    }

    private static func filterOnPaths(files: inout Set<TestFile>, with filterRule: FilterRule) {
        var excludedFiles = Set<TestFile>()
        if let excludedPaths = filterRule.excludedPaths {
            excludedFiles = matching(files: files, withPaths: excludedPaths)
        }

        if let includedPaths = filterRule.includedPaths {
            files = matching(files: files, withPaths: includedPaths)
        }

        files = files.subtracting(excludedFiles)
    }

    private static func matching(files: Set<TestFile>, withPaths paths: Set<String>) -> Set<TestFile> {
        var matchingFiles = Set<TestFile>()
        for file in files {
            for path in paths {
                if !RegExMatcher.matches(for: path, in: file.path).isEmpty {
                    matchingFiles.insert(file)
                }
            }
        }
        return matchingFiles
    }

    private static func filterOnFilesNames(files: inout Set<TestFile>, with filterRule: FilterRule) {
        var excludedFiles = Set<TestFile>()
        if let excludedFilesNames = filterRule.excludedFilesNames {
            excludedFiles = matching(files: files, withNames: excludedFilesNames)
        }

        if let includedFilesNames = filterRule.includedFilesNames {
            files = matching(files: files, withNames: includedFilesNames)
        }

        files = files.subtracting(excludedFiles)
    }

    private static func matching(files: Set<TestFile>, withNames names: Set<String>) -> Set<TestFile> {
        var matchingFiles = Set<TestFile>()
        for file in files {
            for name in names {
                if !RegExMatcher.matches(for: name, in: file.name).isEmpty {
                    matchingFiles.insert(file)
                }
            }
        }
        return matchingFiles
    }

    private static func filterOnFunctionsNames(files: inout Set<TestFile>, with filterRule: FilterRule) {
        guard var mExcludedFunctionsNames = filterRule.excludedFunctionsNames else { return }

        var mFiles = Set<TestFile>()
        for file in files {
            var mFile = file
            for function in mFile.functions {
                for name in mExcludedFunctionsNames {
                    guard !RegExMatcher.matches(for: name, in: function.name).isEmpty else { continue }

                    mExcludedFunctionsNames.remove(name)
                    mFile.functions.remove(function)
                    recalculateTestFileLines(&mFile)
                    break
                }
            }
            if !mFile.functions.isEmpty {
                mFiles.insert(mFile)
            }
        }
        files = mFiles
    }

    private static func recalculateTestFileLines(_ testFile: inout TestFile) {
        var coveredLines = 0
        var executableLines = 0
        var lineCoverage = 0.0
        testFile.functions.forEach { function in
            coveredLines += function.coveredLines
            executableLines += function.executableLines
        }
        if executableLines > 0 {
            lineCoverage = Double(coveredLines) / Double(executableLines)
        }
        testFile.coveredLines = coveredLines
        testFile.executableLines = executableLines
        testFile.lineCoverage = lineCoverage
    }

    private static func recalculateTestTargetLines(_ testTarget: inout TestTarget) {
        var coveredLines = 0
        var executableLines = 0
        var lineCoverage = 0.0
        testTarget.files.forEach { file in
            coveredLines += file.coveredLines
            executableLines += file.executableLines
        }
        if executableLines > 0 {
            lineCoverage = Double(coveredLines) / Double(executableLines)
        }
        testTarget.coveredLines = coveredLines
        testTarget.executableLines = executableLines
        testTarget.lineCoverage = lineCoverage
    }

    private static func recalculateTestReportLines(_ testReport: inout TestReport) {
        var coveredLines = 0
        var executableLines = 0
        var lineCoverage = 0.0
        testReport.targets.forEach { target in
            coveredLines += target.coveredLines
            executableLines += target.executableLines
        }
        if executableLines > 0 {
            lineCoverage = Double(coveredLines) / Double(executableLines)
        }
        testReport.coveredLines = coveredLines
        testReport.executableLines = executableLines
        testReport.lineCoverage = lineCoverage
    }
}
