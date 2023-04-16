//
//  Data.swift
//  Marvelist
//
//  Created by Hakan Aktürk on 15.04.2023.
//

import Foundation

struct DataModel: Codable {
    let data: Result
}

struct Result: Codable  {
    let results: [Character]
    let count: Int
    let limit: Int
}

struct Character: Codable, Identifiable, Equatable {
    let id: Int
    let name: String?
    let description: String?
    let thumbnail: Thumbnail?
    let comics, series: Comics?
    let stories: Stories?
    let events: Comics?

    
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }

    static let example = Character(id: 776578, name: "Captain America", description: nil, thumbnail: nil, comics: nil, series: nil, stories: nil, events: nil)
}

struct Comics: Codable {
    let collectionURI: String?
    let items: [ComicsItem]?
}

struct ComicsItem: Codable  {
    let name: String?
}

struct Stories: Codable  {
    let items: [StoriesItem]?
}

struct StoriesItem: Codable  {
    let name: String?
}

struct Thumbnail: Codable  {
    let path: String?
    let `extension`: String?
}

