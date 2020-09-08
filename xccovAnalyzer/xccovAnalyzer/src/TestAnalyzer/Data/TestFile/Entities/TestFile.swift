//
//  TestFile.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 10/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

struct TestFile: Codable, Hashable {
    var coveredLines: Int
    var lineCoverage: Double
    let path: String
    var functions: Set<TestFunction>
    let name: String
    var executableLines: Int
}
