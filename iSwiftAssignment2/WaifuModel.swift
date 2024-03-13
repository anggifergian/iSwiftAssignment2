//
//  WaifuModel.swift
//  iSwiftAssignment2
//
//  Created by Anggi Fergian on 28/02/24.
//

import Foundation

struct Waifu: Codable, Identifiable {
    let id: String
    let image: String
    let anime: String
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case image
        case anime
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = UUID().uuidString
        self.image = try container.decode(String.self, forKey: .image)
        self.anime = try container.decode(String.self, forKey: .anime)
        self.name = try container.decode(String.self, forKey: .name)
    }
}
