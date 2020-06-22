//
//  SettingsProtocols.swift
//  GitManager
//
//  Created by Антон Текутов on 10.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

protocol SettingsViewProtocol {
    
    var presenter: SettingsPresenterProtocol! { get set }
}

protocol SettingsPresenterProtocol {
    
    var view: SettingsViewProtocol? { get set }
    var interactor: SettingsInteractorProtocol! { get set }
    var router: SettingsRouterProtocol! { get set }
    
    // MARK: - input
    func viewDidLoad()
    
    // MARK: - output
    func getMenu() -> [MenuModule]
}

protocol SettingsInteractorProtocol {
    
    var presenter: SettingsPresenterProtocol! { get set }
    
    func clearUserData()
}

protocol SettingsRouterProtocol {
    
    func showProfileEditor()
    func showAuthenticationScreen()
}
