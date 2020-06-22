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
    
    private var _view: AuthenticationView {
        return view as! AuthenticationView
    }

    override func loadView() {
        self.view = AuthenticationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        _view.signInButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        
        presenter?.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
       }
    
    func setupView(){
        self.hideKeyboardWhenTappedAround()

        setupLoading()
    }
    
    private func setupLoading(){
        _view.addSubview(loading)
        loading.setMargin(0)
        //loading.show(animation: false)
    }
    
    func showSignIn() {
        _view.showSignInButton()
    }
    
    func hideLoading() {
        loading.hide()
    }
    
    @objc func loginButtonPressed(){
        presenter?.tryToAuthenticate()
    }
    
    
}
