//
//  PokemonDetailView.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

import SwiftUI

public struct PokemonDetailView: View {
    @StateObject public var viewModel: PokemonDetailViewModel
    public let pokemonID: Int
    
    public init(viewModel: PokemonDetailViewModel, pokemonID: Int) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.pokemonID = pokemonID
    }
    
    public var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: gradientColors()),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
            } else if let pokemon = viewModel.pokemon {
                ScrollView {
                    VStack(spacing: 20) {
                        AsyncImage(url: URL(string: pokemon.sprites.frontDefault ?? "")) { image in
                            image.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 200, height: 200)
                        .shadow(radius: 10)
                        
                        Text(pokemon.name.capitalized)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 10) {
                            ForEach(pokemon.types, id: \.type.name) { typeEntry in
                                Text(typeEntry.type.name.capitalized)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(color(for: typeEntry.type.name))
                                    .cornerRadius(12)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        HStack(spacing: 20) {
                            StatCard(title: "Height", value: "\(pokemon.height)")
                            StatCard(title: "Weight", value: "\(pokemon.weight)")
                        }
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Stats")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                            
                            ForEach(pokemon.stats, id: \.stat.name) { statEntry in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(statEntry.stat.name.capitalized)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                    
                                    StatBar(value: statEntry.base_stat)
                                }
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding()
                }
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .onAppear {
            viewModel.fetchPokemon(id: pokemonID)
        }
    }
    
    func color(for type: String) -> Color {
        switch type.lowercased() {
        case "fire": return .red
        case "water": return .blue
        case "grass": return .green
        case "electric": return .yellow
        case "ice": return .cyan
        case "psychic": return .purple
        case "ground": return .brown
        case "rock": return .gray
        case "fairy": return .pink
        case "dark": return .black
        case "ghost": return .indigo
        case "bug": return .green.opacity(0.7)
        case "normal": return .gray.opacity(0.7)
        case "fighting": return .orange
        case "poison": return .purple.opacity(0.7)
        case "steel": return .gray
        case "dragon": return .blue.opacity(0.8)
        default: return .gray
        }
    }

    private func gradientColors() -> [Color] {
        guard let firstType = viewModel.pokemon?.types.first?.type.name else {
            return [Color.gray, Color.black]
        }
        
        let primary = color(for: firstType)
        
        return [primary.opacity(0.6), primary.opacity(0.9)]
    }
}

// MARK: - Subviews

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            Text(value)
                .font(.headline)
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.black.opacity(0.25))
        .cornerRadius(10)
    }
}

struct StatBar: View {
    let value: Int
    var maxValue: CGFloat = 200
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.white.opacity(0.2))
                .frame(height: 12)
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.green)
                .frame(width: CGFloat(value) / maxValue * 200, height: 12)
        }
    }
}
