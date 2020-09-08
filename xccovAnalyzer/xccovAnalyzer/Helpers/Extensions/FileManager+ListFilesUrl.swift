//
//  FileManager+ListFilesUrl.swift
//  xccovAnalyzer
//
//  Created by Emiliano Alvarez on 10/08/2020.
//  Copyright © 2020 Emiliano Alvarez. All rights reserved.
//

import Foundation

extension FileManager {

    func urls(at documentsURL: URL, withPathExtension pathExtension: String? = nil) -> [URL]? {
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: [])
        if let pathExtension = pathExtension {
            return fileURLs?.filter { $0.pathExtension == pathExtension }
        }
        return fileURLs
    }
}
