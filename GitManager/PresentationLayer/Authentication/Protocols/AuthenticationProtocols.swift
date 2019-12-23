//
//  AuthenticationProtocols.swift
//  GitManager
//
//  Created by Антон Текутов on 22.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

protocol AuthenticationViewProtocol: class {
    
    var presenter:  AuthenticationPresenterProtocol?    { get set }
    
    func hideLoading()
    func showErrorMessage()
}

protocol AuthenticationPresenterProtocol: class {
    
    var view:       AuthenticationViewProtocol?         { get set }
    var interactor: AuthenticationInteractorProtocol?   { get set }
    var router:     AuthenticationRouterProtocol?       { get set }
    
    func viewDidLoad()
    func tryToAuthenticate(login: String, password: String)
    func showNextScreen()
    func showErrorMessage()
    func hideLoading()
}

protocol AuthenticationInteractorProtocol: class {
    
    var presenter:  AuthenticationPresenterProtocol?    { get set }
    var keychain:   KeychainServiceProtocol?            { get set }
    var apiService: GitHubApiServiceProtocol?           { get set }
    
    func sendAuthenticationRequest(login: String, password: String)
    func authenticationRequestResult(success: Bool)
    func tryAuthenticationWithSavedUserData()
}

protocol AuthenticationRouterProtocol: class {
        
    func pushMainScreen()
}
