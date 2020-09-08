//
//  ShellScript.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 09/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

class ShellScriptRunnable {

    @discardableResult
    static func run(_ command: String) -> String? {
        let task = Process()
        let pipe = Pipe()

        task.standardOutput = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/bash"
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        
        if let output = String(data: data, encoding: .utf8) {
            return output
        }
        return nil
    }
}

