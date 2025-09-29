//
//  PokedexViewController.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

import UIKit

final class PokedexViewController: UIViewController {
    
    var presenter: PokedexPresenterProtocol?
    private var pokemons: [Pokemon] = []
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = (view.frame.size.width - 40) / 2
        layout.itemSize = CGSize(width: width, height: width + 60)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 15
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PokemonCell.self, forCellWithReuseIdentifier: PokemonCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientBackground()
        setupNavigationBar()
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        presenter?.viewDidLoad()
    }
}

private extension PokedexViewController {
    func setupNavigationBar() {
        title = "Pokédex"
    }

    func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.systemRed.cgColor,
            UIColor.systemOrange.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension PokedexViewController: PokedexViewProtocol {
    func showPokemons(_ pokemons: [Pokemon]) {
        self.pokemons = pokemons
        
        collectionView.reloadData()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ha ocurrido un error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Aceptar", style: .cancel))
        
        present(alert, animated: true)
    }
}

extension PokedexViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCell.identifier, for: indexPath) as? PokemonCell else { return UICollectionViewCell() }
        
        let pokemon = pokemons[indexPath.item]
        cell.configure(with: pokemon)
        
        if indexPath.item == pokemons.count - 1 {
            presenter?.loadMorePokemons()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedPokemon = pokemons[indexPath.item]
        
        presenter?.navigateToPokemonDetail(pokemonID: selectedPokemon.id ?? 0)
    }
}
