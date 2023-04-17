//
//  ComicsData.swift
//  Marvelist
//
//  Created by Hakan Aktürk on 16.04.2023.
//

import Foundation

struct ComicsData: Codable {
    let data: ComicsResult
}

struct ComicsResult: Codable {
    let results: [ComicsDetail]
}

struct ComicsDetail: Codable, Identifiable, Equatable {
    let id: Int
    let title: String
    let description: String?
    let thumbnail: Thumbnail?
    
    static func == (lhs: ComicsDetail, rhs: ComicsDetail) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title
    }
}
