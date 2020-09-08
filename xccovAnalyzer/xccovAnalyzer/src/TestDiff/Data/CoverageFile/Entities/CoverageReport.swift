//
//  CoverageReport.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 30/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

struct CoverageReport: Codable, Hashable {
    let targets: Set<CoverageTarget>
}
