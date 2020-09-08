//
//  main.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 09/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

enum AppArguments: String {
    case analyze, diff, publish
}

func run() {
    guard CommandLine.argc > 1 else {
        MessageWriter.write(message: "Missing argument. Please check Readme file", .error)
        return
    }

    switch CommandLine.arguments[1] {
    case AppArguments.analyze.rawValue:
        var xcresultFilePath: String? = nil
        if CommandLine.argc > 2 {
           xcresultFilePath = CommandLine.arguments[2]
        }
        TestAnalyzer.analyze(xcresultFilePath)
    case AppArguments.diff.rawValue:
        TestDiff.diff()
    case AppArguments.publish.rawValue:
        guard CommandLine.argc > 6 else {
            MessageWriter.write(message: "Missing publish arguments, arguments:\(CommandLine.argc)/6. Please check Readme file", .error)
            return
        }
        let owner = CommandLine.arguments[2]
        let repo = CommandLine.arguments[3]
        let pullNumber = CommandLine.arguments[4]
        let username = CommandLine.arguments[5]
        let personalAccessToken = CommandLine.arguments[6]

        let githubPublisher = GithubReviewPublisher(owner: owner, repo: repo, pullNumber: pullNumber, username: username, personalAccessToken: personalAccessToken)
        CoveragePublisher.publish(with: githubPublisher)
    default:
        MessageWriter.write(message: "Invalid argument. Please check Readme file for supported arguments", .error)
    }
}

run()
