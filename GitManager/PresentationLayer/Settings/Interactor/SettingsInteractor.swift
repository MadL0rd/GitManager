//
//  SettingsInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 10.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import Foundation

class SettingsInteractor: SettingsInteractorProtocol {
    
    var presenter:  SettingsPresenterProtocol!
    
    var keychain:   KeychainServiceProtocol?
    
    func clearUserData(){
        keychain?.clearPrivateUserData()
    }
}
