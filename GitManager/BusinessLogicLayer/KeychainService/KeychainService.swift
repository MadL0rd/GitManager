//
//  KeychainService.swift
//  GitManager
//
//  Created by Антон Текутов on 25.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import KeychainSwift

class KeychainService: KeychainServiceProtocol {
    
    private let keychain = KeychainSwift(keyPrefix: Keys.prefix)
    
    func getUserToken() -> String? {
        return keychain.get(Keys.tokenKey)
    }
    
    func setUserToken(_ token: String) {
        keychain.set(token, forKey: Keys.tokenKey, withAccess: .accessibleAlways)
    }
    
    func clearPrivateUserData() {
        keychain.delete(Keys.tokenKey)
    }
}

private struct Keys{
    static let prefix       = "Fe9f6yYUVJg3AynP"
    static let tokenKey     = "9AM78HPKp7V9kERE"
}
