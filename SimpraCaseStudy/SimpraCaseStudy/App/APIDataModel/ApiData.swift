//
//  CharacterData.swift
//  week7CoreData
//
//  Created by Sefa İbiş on 17.01.2023.
//

import Foundation

// MARK: - GameResponse
struct GamesResponse: Decodable {
    let count: Int?
    let next: String?
    let results: [Result]?
}
// MARK: - Result
struct Result: Decodable {
    let id: Int?
    let name, released: String?
    let backgroundImage: String?
    let rating: Double?
    let playtime: Int?
    let ratingsCount: Int?
    let parentPlatforms: [ParentPlatform]?
    let genres: [Genre]?
    let stores: [Store]?
    let tags: [Tags]?

    enum CodingKeys: String, CodingKey {
        case id, name, released
        case backgroundImage = "background_image"
        case rating
        case playtime
        case ratingsCount = "ratings_count"
        case parentPlatforms = "parent_platforms"
        case genres, stores, tags
    }
}

struct ParentPlatform: Decodable {
    let platform: Platform?
}

struct Platform: Codable {
    let id: Int?
    let name: String?
}

struct Store: Decodable {
    let id: Int?
    let store: Stores?
}

struct Stores: Decodable {
    let id: Int?
    let name: String?
}

struct Tags: Decodable {
    let id: Int?
    let name: String?
}

struct Genre: Decodable {
    let id: Int?
    let name: String?
}


