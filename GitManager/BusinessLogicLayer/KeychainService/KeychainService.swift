//
//  KeychainService.swift
//  GitManager
//
//  Created by Антон Текутов on 25.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import KeychainSwift

class KeychainService: KeychainServiceProtocol {
    
    let keychain = KeychainSwift(keyPrefix: Keys.prefix)
    
    func getPrivateUserData() -> (login: String, password: String) {
        let login : String = keychain.get(Keys.loginKey) ?? ""
        let password : String = keychain.get(Keys.passwordKey) ?? ""
        return (login, password)
    }
    
    func setPrivateUserData(login: String, password: String) {
        keychain.set(login      , forKey: Keys.loginKey, withAccess: .accessibleAlways)
        keychain.set(password   , forKey: Keys.passwordKey, withAccess: .accessibleAlways)
    }
    
    func clearPrivateUserData() {
        keychain.delete(Keys.loginKey)
        keychain.delete(Keys.passwordKey)
    }
}

private struct Keys{
    static let prefix       = "my_prefix"
    static let loginKey     = "logogogin"
    static let passwordKey  = "passassasword"
}
