//
//  AuthenticationInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 22.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class AuthenticationInteractor: AuthenticationInteractorProtocol {
    
    var apiService: GitHubApiServiceProtocol?
    var keychain:   KeychainServiceProtocol?
    var presenter:  AuthenticationPresenterProtocol?
    var multiRequestBlocker = true
    
    private var loginBuff: String = ""
    private var passwordBuff: String = ""
    
    func sendAuthenticationRequest(login: String, password: String) {
        if multiRequestBlocker {
            multiRequestBlocker = false
            loginBuff = login
            passwordBuff = password
            apiService?.authentication(login: login, password: password, callBack: self.getAuthenticationRequestResult)
        }
    }
    
    func getAuthenticationRequestResult(success: Bool) {
        multiRequestBlocker = true
        if success {
            keychain?.setPrivateUserData(login: loginBuff, password: passwordBuff)
            presenter?.showNextScreen()
        }else{
            presenter?.showErrorMessage()
        }
    }
    
    func tryAuthenticationWithSavedUserData() {
        if let data = keychain?.getPrivateUserData(){
            if data.login != "" && data.password != "" {
                sendAuthenticationRequest(login: data.login, password: data.password)
            }
        }
    }
    
}
