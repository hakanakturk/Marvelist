//
//  FileManager-DocumentsDirectory.swift
//  Marvelist
//
//  Created by Hakan Aktürk on 13.04.2023.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
