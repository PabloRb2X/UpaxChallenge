//
//  LoginViewController.swift
//  UpaxChallenge
//
//  Created by Pablo Ramirez on 27/09/25.
//

import UIKit

final class LoginViewController: UIViewController {
    
    var presenter: LoginPresenterProtocol?
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let usernameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "User"
        textField.autocapitalizationType = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.setLeftPaddingPoints(12)
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.1
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowRadius = 4
        
        return textField
    }()
    
    private let passwordField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 12
        textField.setLeftPaddingPoints(12)
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOpacity = 0.1
        textField.layer.shadowOffset = CGSize(width: 0, height: 2)
        textField.layer.shadowRadius = 4
        
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LOGIN", for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("REGISTER", for: .normal)
        button.backgroundColor = UIColor.systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return button
    }()
    
    private let loader = LoaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        title = "PokeAPI"
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTapped), for: .touchUpInside)
    }
}

private extension LoginViewController {
    func configureUI() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemPurple.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        let stackView = UIStackView(arrangedSubviews: [usernameField, passwordField, loginButton, registerButton])
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        stackView.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
    }
    
    @objc func loginTapped() {
        showLoader()
        presenter?.login(username: usernameField.text, password: passwordField.text)
    }
    
    @objc func registerTapped() {
        showLoader()
        presenter?.register(username: usernameField.text, password: passwordField.text)
    }
}

extension LoginViewController: LoginViewProtocol {
    func showError(message: String) {
        let alert = UIAlertController(title: "Has ocurred an error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        
        present(alert, animated: true)
    }
    
    func showSuccess(message: String) {
        let alert = UIAlertController(title: "Login Successfull", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true)
    }
    
    func showLoader() {
        loader.show(on: view)
    }
    
    func hideLoader() {
        loader.hide()
    }
}

private extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
