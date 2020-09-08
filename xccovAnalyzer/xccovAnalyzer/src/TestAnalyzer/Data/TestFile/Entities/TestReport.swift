//
//  TestReport.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 10/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

struct TestReport: Codable, Equatable {
    var coveredLines: Int
    var lineCoverage: Double
    var targets: [TestTarget]
    var executableLines: Int
}
