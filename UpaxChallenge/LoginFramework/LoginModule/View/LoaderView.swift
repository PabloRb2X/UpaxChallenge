//
//  LoaderView.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 28/09/25.
//

import UIKit

final class LoaderView: UIView {
    
    private let spinner: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.color = .white
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.hidesWhenStopped = true
        
        return activityIndicatorView
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    private func setupUI() {
        backgroundColor = UIColor.clear
        
        addSubview(backgroundView)
        addSubview(spinner)
        
        NSLayoutConstraint.activate([
            backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: 100),
            backgroundView.heightAnchor.constraint(equalToConstant: 100),
            
            spinner.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor)
        ])
    }
    
    // MARK: - Show / Hide
    func show(on view: UIView) {
        frame = view.bounds
        alpha = 0
        view.addSubview(self)
        spinner.startAnimating()
        
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.alpha = 1
        }
    }
    
    func hide() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.alpha = 0
        }) { [weak self] _ in
            self?.spinner.stopAnimating()
            self?.removeFromSuperview()
        }
    }
}
