//
//  TestReportDiffTests.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 30/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import XCTest

class TestReportComparatorTests: XCTestCase {

    let originalTestReport: TestReport = JsonCoder.decode(fileName: "TestReportOriginalData")

    func testCompareTestReports_withNoHistoryReport_shouldReturnOriginalCodeCoverageReport() {
        let expectedCoverageReport: CoverageReport = JsonCoder.decode(fileName: "CoverageReportNoHistoryData")
        let codeCoverageReport = TestReportComparator.compareTestReports(originalTestReport, historyTestReport: nil)

        XCTAssertEqual(codeCoverageReport, expectedCoverageReport)
    }

    func testCompareTestReports_withHistoryReport_shouldReturnDifferenceCodeCoverageReport() {
        let expectedCoverageReport: CoverageReport = JsonCoder.decode(fileName: "CoverageReportWithHistoryData")
        let historyTestReport: TestReport = JsonCoder.decode(fileName: "TestReportHistoryData")
        let codeCoverageReport = TestReportComparator.compareTestReports(originalTestReport, historyTestReport: historyTestReport)

        XCTAssertEqual(codeCoverageReport, expectedCoverageReport)
    }
}
