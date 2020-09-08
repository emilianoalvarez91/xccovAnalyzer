//
//  GithubReview.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 31/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

struct GithubReview: Codable {
    let id: Int
    let body: String
    let state: String
}
