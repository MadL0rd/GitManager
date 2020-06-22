//
//  KeychainServiceProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 25.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import KeychainSwift

protocol KeychainServiceProtocol: class {
    
    func getUserToken() -> String?
    func setUserToken(_ token: String)
    func clearPrivateUserData()
}
