//
//  TestFileLocator.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 10/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

class TestFileLocator {

    private static let derivedDataPathPattern = ".*/DerivedData/\\w*-\\w*/"
    private static let testsPath = "Logs/Test"
    private static let testFileExtension = "xcresult"
    private static let xcodeBuildScript = "xcodebuild -project %@ -showBuildSettings | grep -m 1 \"BUILD_DIR\" | grep -oEi \"\\/.*\" "

    static func locate(projectRelativePath: String) -> URL? {
        let projectPath = Bundle.main.bundleURL.appendingPathComponent(projectRelativePath).path
        guard let binaryPath = ShellScriptRunnable.run(String(format: xcodeBuildScript, "\(projectPath)")) else {
            fatalError("Couldn't build project at path for \(projectPath)")
        }

        guard let derivedDataPath = RegExMatcher.matches(for: derivedDataPathPattern, in: binaryPath, escapingPattern: false).first else {
            fatalError("Couldn't find derived data path for \(projectPath). BinaryPath: \(binaryPath)")
        }

        let testDirectoryUrl = URL(fileURLWithPath: derivedDataPath).appendingPathComponent(testsPath)
        let testFileUrl = FileManager.default.urls(at: testDirectoryUrl, withPathExtension: testFileExtension)?.first
        return testFileUrl
    }
}
