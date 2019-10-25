//
//  KeychainServiceProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 25.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import KeychainSwift

protocol KeychainServiceProtocol: class {
    var keychain: KeychainSwift { get }
    
    func getPrivateUserData() -> (login: String, password: String)
    func setPrivateUserData(login: String, password: String)
    func clearPrivateUserData()
}
