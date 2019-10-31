//
//  AuthenticationViewController.swift
//  GitManager
//
//  Created by Антон Текутов on 19.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//
import UIKit

class AuthenticationViewController: UIViewController, AuthenticationViewProtocol {
    
    var presenter: AuthenticationPresenterProtocol?
    let form: AuthenticationForm = {
        let view = AuthenticationForm()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func showErrorMessage() {
        form.loginButton.setBlocked()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupView()
        
        presenter?.viewDidLoad()
    }
    
    func setupView(){
        view.addSubview(form)
        
        form.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65).isActive = true
        form.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        form.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        form.loginTextField.addTarget(self, action: #selector(textConteinsCheck), for: .editingChanged)
        form.passwordTextField.addTarget(self, action: #selector(textConteinsCheck), for: .editingChanged)
        form.loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    @objc func textConteinsCheck(){
        if form.textFieldsIsNotEmpty(){
            form.loginButton.setActive()
        }else{
            form.loginButton.setBlocked()
        }
    }
    
    @objc func loginButtonPressed(){
        presenter?.tryToAuthenticate(login: form.loginTextField.text ?? "", password: form.passwordTextField.text ?? "")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
