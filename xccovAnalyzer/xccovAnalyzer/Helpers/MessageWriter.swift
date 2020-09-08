//
//  MessageWriter.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 30/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

enum MessageOutputType {
    case normal, error, success, warning
}

class MessageWriter {
        
    static func write(message: String, _ outputType: MessageOutputType = .normal) {
        switch outputType {
        case .normal:
            print("\(cyanColor)\(message)\(resetColor)")
        case .error:
            print("\(redColor)\(message)\n\(resetColor)")
        case .success:
            print("\(greenColor)\(message)\n\(resetColor)")
        case .warning:
            print("\(yellowColor)\(message)\n\(resetColor)")
        }
    }

    private static let colorSequence = "\u{001B}["
    private static let redColor = "\(colorSequence)0;31m"
    private static let greenColor = "\(colorSequence)0;32m"
    private static let yellowColor = "\(colorSequence)0;33m"
    private static let cyanColor = "\(colorSequence)0;36m"
    private static let resetColor = "\(colorSequence);m"
}
