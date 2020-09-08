//
//  TestTarget.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 16/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

struct TestTarget: Codable, Equatable {
    var coveredLines: Int
    var lineCoverage: Double
    var files: Set<TestFile>
    var name: String
    var executableLines: Int
    let buildProductPath: String
}
