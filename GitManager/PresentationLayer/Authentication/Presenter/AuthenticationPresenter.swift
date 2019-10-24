//
//  AuthenticationPresenter.swift
//  GitManager
//
//  Created by Антон Текутов on 22.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class AuthenticationPresenter: AuthenticationPresenterProtocol{
    
    var view: AuthenticationViewProtocol?
    var interactor: AuthenticationInteractorProtocol?
    var router: AuthenticationRouterProtocol?
    
    func tryToAuthenticate(login: String, password: String) {
        interactor?.sendAuthenticationRequest(login: login, password: password)
    }
    
    func showNextScreen() {
        router?.pushMainScreen()
    }
    
    func showErrorMessage() {
        view?.showErrorMessage()
    }
    
}
