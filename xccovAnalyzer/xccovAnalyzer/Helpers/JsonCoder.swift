//
//  JsonCoder.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 10/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

class JsonCoder {

    private static let fileExtension = ".json"

    static func decode<T: Decodable>(fileName: String) -> T {
        let bundle = Bundle(for: JsonCoder.self)
        guard let jsonPath = bundle.url(forResource: fileName, withExtension: fileExtension) else {
            fatalError("Couldn't find \(fileName) in app bundle \(bundle)")
        }

       return decode(fileURL: jsonPath)
    }

    static func decode<T: Decodable>(fileURL: URL) -> T {
        let data: Data
        do {
          data = try Data(contentsOf: fileURL)
        } catch {
          fatalError("Couldn't load \(fileURL) from main bundle:\n\(error)")
        }

        return decode(data: data)
    }

    static func decode<T: Decodable>(json: String) -> T {
        guard let data: Data = json.data(using: .utf8) else {
            fatalError("Couldn't transform \(json) into data")
        }
        return decode(data: data)
    }

    private static func decode<T: Decodable>(data: Data) -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't decode data as \(T.self):\n\(error)")
        }
    }

    static func encode<T: Encodable>(object: T) -> String {
        let encoder = JSONEncoder()

        do {
            let jsonData = try encoder.encode(object)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                fatalError("Empty String returned when parsing as \(T.self)")
            }
            return jsonString
        } catch {
            fatalError("Couldn't encode \((T.self)):\n\(error)")
        }
    }
}
