//
//  ConfigFileDecoder.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 10/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

class ConfigFileDecoder {

    private static let configYmlFileName = "xccovConfig.yml"

    static func decode() -> Config {
        guard let scriptPath = Bundle.main.resourcePath else {
            fatalError("Couldn't read script folder path")
        }

        let ymlConfigFileUrl = URL(fileURLWithPath: scriptPath).appendingPathComponent(configYmlFileName)
        return YamlDecoder.decode(ymlConfigFileUrl)
    }
}
