//
//  FileManager+WriteToFile.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 17/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

extension FileManager {

    func write(string: String, fileName: String) {
        guard var path = Bundle.main.resourceURL else {
            fatalError("Couldn't read script folder path")
        }
        path.appendPathComponent(fileName)

        do {
            try string.write(to: path, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            fatalError("Failed to write file named \(fileName) in path \(path)")
        }
    }
}
