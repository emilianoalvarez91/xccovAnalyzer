//
//  UnitTests.swift
//  UnitTests
//
//  Created by Emiliano Alvarez on 16/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import XCTest

class TestReportFilterTests: XCTestCase {

    let originalTestReport: TestReport = JsonCoder.decode(fileName: "TestReportOriginalData")

    func testTestReportFilter_withNoRules_shouldReturnOriginalTestReport() {
        let expectedTestReport: TestReport = JsonCoder.decode(fileName: "TestReportOriginalData")
        let filterRules = [FilterRule]()

        let filteredTestReport = TestReportFilter.filter(originalTestReport, filterRules: filterRules)

        XCTAssertEqual(filteredTestReport, expectedTestReport)
    }

    func testTestReportFilter_withOneTargetName_shouldReturnOneTargetTestReport() {
        let expectedTestReport: TestReport = JsonCoder.decode(fileName: "TestReportOneTargetData")
        let filterRule = FilterRule(targetName: "Testing123.app")
        let filterRules = [filterRule]

        let filteredTestReport = TestReportFilter.filter(originalTestReport, filterRules: filterRules)

        XCTAssertEqual(filteredTestReport, expectedTestReport)
    }

    func testTestReportFilter_withAllTargetNames_shouldReturnOriginalTestReport() {
        let expectedTestReport: TestReport = JsonCoder.decode(fileName: "TestReportOriginalData")
        let filterRule1 = FilterRule(targetName: "Testing123.app")
        let filterRule2 = FilterRule(targetName: "Testing123Tests.xctest")
        let filterRules = [filterRule1, filterRule2]

        let filteredTestReport = TestReportFilter.filter(originalTestReport, filterRules: filterRules)

        XCTAssertEqual(filteredTestReport, expectedTestReport)
    }

    func testTestReportFilter_withOneTargetNameAndIncludedOnePath_shouldReturnFilteredTestReport() {
        let expectedTestReport: TestReport = JsonCoder.decode(fileName: "TestReportOneTargetIncludedPathData")
        let filterRule = FilterRule(targetName: "Testing123.app", includedPaths: ["src"])
        let filterRules = [filterRule]

        let filteredTestReport = TestReportFilter.filter(originalTestReport, filterRules: filterRules)

        XCTAssertEqual(filteredTestReport, expectedTestReport)
    }

    func testTestReportFilter_withOneTargetNameAndIncludedAllPaths_shouldReturnOneTargetTestReport() {
        let expectedTestReport: TestReport = JsonCoder.decode(fileName: "TestReportOneTargetData")
        let filterRule = FilterRule(targetName: "Testing123.app", includedPaths: ["src", "etc"])
        let filterRules = [filterRule]

        let filteredTestReport = TestReportFilter.filter(originalTestReport, filterRules: filterRules)
        XCTAssertEqual(filteredTestReport, expectedTestReport)
    }

    func testTestReportFilter_withTwoTargetNamesAndIncludedAllPaths_shouldReturnOriginalTestReport() {
        let expectedTestReport: TestReport = JsonCoder.decode(fileName: "TestReportOriginalData")
        let filterRule1 = FilterRule(targetName: "Testing123.app", includedPaths: ["src", "etc"])
        let filterRule2 = FilterRule(targetName: "Testing123Tests.xctest", includedPaths: ["src", "Testing123Tests"])
        let filterRules = [filterRule1, filterRule2]

        let filteredTestReport = TestReportFilter.filter(originalTestReport, filterRules: filterRules)
        XCTAssertEqual(filteredTestReport, expectedTestReport)
    }

    func testTestReportFilter_withOneTargetNameAndIncludedAndExcludedPaths_shouldReturnFilteredTestReport() {
        let expectedTestReport: TestReport = JsonCoder.decode(fileName: "TestReportOneTargetIncludedExcludedPathsData")
        let filterRule = FilterRule(targetName: "Testing123.app", includedPaths: ["src"], excludedPaths: ["src/Views", "etc"])
        let filterRules = [filterRule]

        let filteredTestReport = TestReportFilter.filter(originalTestReport, filterRules: filterRules)

        XCTAssertEqual(filteredTestReport, expectedTestReport)
    }

    func testTestReportFilter_withTwoTargetNamesAndIncludedAndExcludedPaths_shouldReturnFilteredTestReport() {
        let expectedTestReport: TestReport = JsonCoder.decode(fileName: "TestReportTwoTargetsIncludedExcludedPathsData")
        let filterRule1 = FilterRule(targetName: "Testing123.app", excludedPaths: ["src"])
        let filterRule2 = FilterRule(targetName: "Testing123Tests.xctest", excludedPaths: ["Testing123Tests"])
        let filterRules = [filterRule1, filterRule2]

        let filteredTestReport = TestReportFilter.filter(originalTestReport, filterRules: filterRules)

        XCTAssertEqual(filteredTestReport, expectedTestReport)
    }

    func testTestReportFilter_withIncludedFilesNames_shouldReturnFilteredTestReport() {
        let expectedTestReport: TestReport = JsonCoder.decode(fileName: "TestReportIncludedFilesNamesData")
        let filterRule = FilterRule(targetName: "Testing123.app", excludedPaths: ["src/ViewModels"], includedFilesNames: ["Delegate.swift", "ViewController.swift"])
        let filterRules = [filterRule]

        let filteredTestReport = TestReportFilter.filter(originalTestReport, filterRules: filterRules)

        XCTAssertEqual(filteredTestReport, expectedTestReport)
    }

    func testTestReportFilter_withExcludedFilesNames_shouldReturnFilteredTestReport() {
        let expectedTestReport: TestReport = JsonCoder.decode(fileName: "TestReportExcludedFilesNamesData")
        let filterRule = FilterRule(targetName: "Testing123.app", excludedFilesNames: ["Delegate.swift", "ViewController.swift"])
        let filterRules = [filterRule]

        let filteredTestReport = TestReportFilter.filter(originalTestReport, filterRules: filterRules)

        XCTAssertEqual(filteredTestReport, expectedTestReport)
    }

    func testTestReportFilter_withIncludedAndExcludedFilesNames_shouldReturnFilteredTestReport() {
        let expectedTestReport: TestReport = JsonCoder.decode(fileName: "TestReportIncludedExcludedFilesNamesData")
        let filterRule = FilterRule(targetName: "Testing123.app", includedFilesNames: ["Delegate.swift", "ViewModel.swift"], excludedFilesNames: ["AppDelegate.swift"])
        let filterRules = [filterRule]

        let filteredTestReport = TestReportFilter.filter(originalTestReport, filterRules: filterRules)

        XCTAssertEqual(filteredTestReport, expectedTestReport)
    }

    func testTestReportFilter_withExcludedFunctionNames_shouldReturnFilteredTestReport() {
        let expectedTestReport: TestReport = JsonCoder.decode(fileName: "TestReportExcludedFunctionsData")
        let filterRule = FilterRule(targetName: "Testing123.app", includedFilesNames: ["Delegate.swift", "ViewModel.swift"], excludedFilesNames: ["AppDelegate.swift"], excludedFunctionsNames: ["HomeViewModel.notTestedMethod()", "HomeViewModel.partiallyTested() -> Swift.String", "SceneDelegate.sceneDidBecomeActive(__C.UIScene) -> ()"])
        let filterRules = [filterRule]

        let filteredTestReport = TestReportFilter.filter(originalTestReport, filterRules: filterRules)

        XCTAssertEqual(filteredTestReport, expectedTestReport)
    }

    func testTestReportFilter_withExcludedAllFunctionsNamesFromFile_shouldReturnFilteredTestReportWithRemovedTest() {
        let expectedTestReport: TestReport = JsonCoder.decode(fileName: "TestReportExcludedAllFunctionsFileData")
        let filterRule = FilterRule(targetName: "Testing123.app", includedFilesNames: ["Delegate.swift", "ViewModel.swift"], excludedFilesNames: ["AppDelegate.swift"], excludedFunctionsNames: ["HomeViewModel.notTestedMethod()", "HomeViewModel.partiallyTested() -> Swift.String", "SceneDelegate.sceneDidBecomeActive(__C.UIScene) -> ()", "HomeViewModel.testme() -> Swift.String"])
        let filterRules = [filterRule]

        let filteredTestReport = TestReportFilter.filter(originalTestReport, filterRules: filterRules)

        XCTAssertEqual(filteredTestReport, expectedTestReport)
    }

    func testTestReportFilter_withMultipleEqualTargetNames_shouldReturnMultipleTestReports() {
        let expectedTestReport: TestReport = JsonCoder.decode(fileName: "TestReportMultipleEqualTargetsData")
        let filterRule1 = FilterRule(targetName: "Testing123.app", displayName: "Unit Tests", includedFilesNames: ["Delegate.swift", "ViewModel.swift"], excludedFilesNames: ["AppDelegate.swift"], excludedFunctionsNames: ["HomeViewModel.notTestedMethod()", "HomeViewModel.partiallyTested() -> Swift.String", "SceneDelegate.sceneDidBecomeActive(__C.UIScene) -> ()", "HomeViewModel.testme() -> Swift.String"])
        let filterRule2 = FilterRule(targetName: "Testing123.app", displayName: "Integration Tests", excludedPaths: ["src/ViewModels"], includedFilesNames: ["Delegate.swift", "ViewController.swift"])
        let filterRules = [filterRule1, filterRule2]

        let filteredTestReport = TestReportFilter.filter(originalTestReport, filterRules: filterRules)

        XCTAssertEqual(filteredTestReport, expectedTestReport)
    }
}
