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
    private var loading: LoadingViewProtocol = LoadingView()
    let form: AuthenticationForm = {
        let view = AuthenticationForm()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func showErrorMessage() {
        form.loginButton.setBlocked()
        UIView.animate(withDuration: 0.5) {
            self.form.errorLabel.alpha = 1
        }
        loading.hide()
    }
    
    func hideLoading() {
        loading.hide()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainBackground
        setupView()
        presenter?.viewDidLoad()
    }
    
    func setupView(){
        setupForm()
        setupLoading()
    }
    
    private func setupForm(){
        view.addSubview(form)
        
        form.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65).isActive = true
        form.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        form.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        form.loginTextField.addTarget(self, action: #selector(textConteinsCheck), for: .editingChanged)
        form.passwordTextField.addTarget(self, action: #selector(textConteinsCheck), for: .editingChanged)
        form.loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    private func setupLoading(){
        view.addSubview(loading)
        
        loading.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        loading.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loading.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loading.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        loading.show(animation: false)
    }

    
    @objc func textConteinsCheck(){
        if form.textFieldsIsNotEmpty(){
            form.loginButton.setActive()
            if form.errorLabel.alpha != 0{
                UIView.animate(withDuration: 0.5) {
                    self.form.errorLabel.alpha = 0
                }
            }
        }else{
            form.loginButton.setBlocked()
        }
    }
    
    @objc func loginButtonPressed(){
        presenter?.tryToAuthenticate(login: form.loginTextField.text ?? "", password: form.passwordTextField.text ?? "")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}
