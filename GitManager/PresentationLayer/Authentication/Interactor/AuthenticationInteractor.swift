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
    
    func sendAuthenticationRequest() {
        if multiRequestBlocker {
            multiRequestBlocker = false
            apiService?.createTokenAndAuthenticate(callback: authenticationRequestResult(success:))
        }
    }
    
    func authenticationRequestResult(success: Bool) {
        multiRequestBlocker = true
        if success {
            presenter?.showNextScreen()
        } else {
            presenter?.showSignIn()
        }
    }
    
    func tryAuthenticationWithSavedUserData() {
        if let _ = keychain?.getUserToken() {
            apiService?.authenticate(callback: authenticationRequestResult)
        } else {
            presenter?.showSignIn()
        }
    }
    
}
