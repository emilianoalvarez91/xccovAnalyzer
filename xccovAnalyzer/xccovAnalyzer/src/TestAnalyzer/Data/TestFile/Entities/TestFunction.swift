//
//  TestFunction.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 16/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

struct TestFunction: Codable, Hashable {
    let coveredLines: Int
    let lineCoverage: Double
    let lineNumber: Int
    let executionCount: Int
    let name: String
    let executableLines: Int
}
