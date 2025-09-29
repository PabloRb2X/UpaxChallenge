//
//  PokemonCell.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

import UIKit

final class PokemonCell: UICollectionViewCell {

    static let identifier = "PokemonCell"
    
    private var currentImageURL: URL?

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 3)
        view.layer.shadowRadius = 6
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo")?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Prepare for Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(systemName: "photo")
        currentImageURL = nil
        nameLabel.text = nil
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(nameLabel)
        
        containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true
        containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5).isActive = true
        containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5).isActive = true
        containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5).isActive = true
        
        imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.6).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8).isActive = true
        nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -10).isActive = true
    }
    
    // MARK: - Configure Cell
    func configure(with pokemon: Pokemon) {
        nameLabel.text = pokemon.name.capitalized
        
        guard let url = pokemon.imageURL else {
            imageView.image = UIImage(systemName: "photo")
            return
        }
        
        currentImageURL = url
        
        ImageCacheManager.shared.loadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            
            if self.currentImageURL == url {
                self.imageView.image = image
            }
        }
    }
}
