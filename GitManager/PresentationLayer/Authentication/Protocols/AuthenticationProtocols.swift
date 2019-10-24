//
//  AuthenticationProtocols.swift
//  GitManager
//
//  Created by Антон Текутов on 22.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

protocol AuthenticationViewProtocol: class {
    
    var presenter: AuthenticationPresenterProtocol? { get set }
    
    func showErrorMessage()
}

protocol AuthenticationPresenterProtocol: class {
    
    var view: AuthenticationViewProtocol? { get set }
    var interactor: AuthenticationInteractorProtocol? { get set }
    var router: AuthenticationRouterProtocol? { get set }
    
    func tryToAuthenticate(login: String, password: String)
    func showNextScreen()
    func showErrorMessage()
}

protocol AuthenticationInteractorProtocol: class {
    
    var presenter: AuthenticationPresenterProtocol? { get set }
    var apiService: GitHubApiServiceProtocol? { get set }
    
    func sendAuthenticationRequest(login: String, password: String)
    func getAuthenticationRequestResult(success: Bool)
    func getUserPrivateData() -> (login: String, password: String)
}

protocol AuthenticationRouterProtocol: class {
        
    func pushMainScreen()
}
