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
    
    var viewLoaded = false
    var needToHideLoading = false
    
    func viewDidLoad() {
        viewLoaded = true
        if needToHideLoading {
            hideLoading()  
        }
    }
    
    func tryToAuthenticate(login: String, password: String) {
        interactor?.sendAuthenticationRequest(login: login, password: password)
    }
    
    func showNextScreen() {
        router?.pushMainScreen()
    }
    
    func showErrorMessage() {
        view?.showErrorMessage()
    }
    
    func hideLoading() {
        if viewLoaded{
            view?.hideLoading()
            needToHideLoading = false
        } else {
            needToHideLoading = true
        }
    }
}
