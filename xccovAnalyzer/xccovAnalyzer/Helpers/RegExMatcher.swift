//
//  RegExMatcher.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 10/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

class RegExMatcher {

    static func matches(for pattern: String, in text: String, escapingPattern: Bool = true) -> [String] {
        do {
            let regex: NSRegularExpression
            if escapingPattern {
                let escapedPattern = NSRegularExpression.escapedPattern(for: pattern)
                regex = try NSRegularExpression(pattern: escapedPattern)
            } else {
                regex = try NSRegularExpression(pattern: pattern)
            }
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { nsString.substring(with: $0.range)}
        } catch let error {
            fatalError("Invalid regEx \(error)")
        }
    }
}
