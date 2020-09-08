//
//  Config.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 09/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

struct Config: Decodable {
    let projectRelativePath: String?
    let filterRules: [FilterRule]?
}
