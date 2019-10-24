//
//  AuthenticationInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 22.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class AuthenticationInteractor: AuthenticationInteractorProtocol {
    
    var apiService: GitHubApiServiceProtocol?
    var presenter: AuthenticationPresenterProtocol?
    var multiRequestBlocker = true
    
    func sendAuthenticationRequest(login: String, password: String) {
        if multiRequestBlocker {
            multiRequestBlocker = false
            apiService?.authentication(login: login, password: password, callBack: self.getAuthenticationRequestResult)
        }
    }
    
    func getAuthenticationRequestResult(success: Bool) {
        multiRequestBlocker = true
        if success {
            presenter?.showNextScreen()
        }else{
            presenter?.showErrorMessage()
        }
    }
    
    func getUserPrivateData() -> (login: String, password: String) {
        return ("kek", "kek")
    }
}
