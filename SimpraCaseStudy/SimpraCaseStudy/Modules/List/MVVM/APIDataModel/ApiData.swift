//
//  CharacterData.swift
//  week7CoreData
//
//  Created by Sefa İbiş on 17.01.2023.
//

import Foundation

struct GamesResponse: Decodable {
    let results: [Result]?
}

struct Result: Decodable {
    let id: Int?
    let name, released, background_image: String?
    let rating: Double?
}
