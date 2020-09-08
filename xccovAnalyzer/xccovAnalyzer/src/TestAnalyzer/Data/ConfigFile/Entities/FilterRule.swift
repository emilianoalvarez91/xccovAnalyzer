//
//  FilterRules.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 16/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

struct FilterRule: Decodable, Hashable {
    let targetName: String
    let displayName: String?
    let includedPaths: Set<String>?
    let excludedPaths: Set<String>?
    let includedFilesNames: Set<String>?
    let excludedFilesNames: Set<String>?
    let excludedFunctionsNames: Set<String>?

    init(
        targetName: String,
        displayName: String? = nil,
        includedPaths: Set<String>? = nil,
        excludedPaths: Set<String>? = nil,
        includedFilesNames: Set<String>? = nil,
        excludedFilesNames: Set<String>? = nil,
        excludedFunctionsNames: Set<String>? = nil
    ) {
        self.targetName = targetName
        self.displayName = displayName
        self.includedPaths = includedPaths
        self.excludedPaths = excludedPaths
        self.includedFilesNames = includedFilesNames
        self.excludedFilesNames = excludedFilesNames
        self.excludedFunctionsNames = excludedFunctionsNames
    }
}
