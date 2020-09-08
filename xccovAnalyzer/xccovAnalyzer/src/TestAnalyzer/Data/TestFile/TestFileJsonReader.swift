//
//  TestJsonParser.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 10/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

class TestFileJsonReader {

    private static let xccovScript = "xcrun xccov view --report --json %@"
    
    static func read(fileUrl: URL) -> String? {
        let output = ShellScriptRunnable.run(String(format: xccovScript, fileUrl.path))
        return output
    }
}
