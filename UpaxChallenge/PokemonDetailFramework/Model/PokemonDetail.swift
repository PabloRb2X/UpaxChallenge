//
//  PokemonDetail.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

import Foundation

public struct PokemonDetail: Decodable, Identifiable {
    public let id: Int
    public let name: String
    public let height: Int
    public let weight: Int
    public let sprites: Sprites
    public let types: [PokemonTypeEntry]
    public let stats: [StatEntry]
    
    public struct Sprites: Decodable {
        public let frontDefault: String?
        
        enum CodingKeys: String, CodingKey {
            case frontDefault = "front_default"
        }
    }
    
    public struct PokemonTypeEntry: Decodable {
        public let type: TypeName
        public struct TypeName: Decodable {
            public let name: String
        }
    }
    
    public struct StatEntry: Decodable {
        public let base_stat: Int
        public let stat: StatInfo
        public struct StatInfo: Decodable {
            public let name: String
        }
    }
    
    public init(id: Int, name: String, height: Int, weight: Int, sprites: Sprites, types: [PokemonTypeEntry], stats: [StatEntry]) {
        self.id = id
        self.name = name
        self.height = height
        self.weight = weight
        self.sprites = sprites
        self.types = types
        self.stats = stats
    }
}
