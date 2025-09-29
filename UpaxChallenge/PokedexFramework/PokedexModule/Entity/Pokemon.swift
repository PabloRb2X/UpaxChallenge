//
//  Pokemon.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//
 
struct Pokemon: Codable {
    let name: String
    let url: String
    
    var id: Int? {
        return Int(url.split(separator: "/").last ?? "")
    }
    
    var imageURL: URL? {
        guard let id = id else { return nil }
        
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
    }
}

struct PokemonResponse: Codable {
    let results: [Pokemon]
    let next: String?
}
