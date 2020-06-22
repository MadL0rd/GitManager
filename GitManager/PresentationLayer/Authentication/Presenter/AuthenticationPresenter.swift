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
    
    func tryToAuthenticate() {
        interactor?.sendAuthenticationRequest()
    }
    
    func showNextScreen() {
        router?.pushMainScreen()
    }
    
    func showSignIn() {
        needToHideLoading = true
        view?.showSignIn()
    }
    
    func hideLoading() {
        if viewLoaded {
            view?.hideLoading()
            needToHideLoading = false
        } else {
            needToHideLoading = true
        }
    }
}
