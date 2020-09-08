//
//  YamlDecoder.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 09/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation
import Yams

class YamlDecoder {

    static func decode<T: Decodable>(_ fileUrl: URL) -> T {
        let yamlString: String
        do {
            yamlString = try String(contentsOf: fileUrl)
        } catch {
          fatalError("Couldn't load \(fileUrl)")
        }

        do {
          let decoder = YAMLDecoder()
          return try decoder.decode(T.self, from: yamlString)
        } catch {
          fatalError("Couldn't parse \(fileUrl) as \(T.self):\n\(error)")
        }
    }
}
