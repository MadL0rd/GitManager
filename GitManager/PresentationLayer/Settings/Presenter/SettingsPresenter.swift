//
//  SettingsPresenter.swift
//  GitManager
//
//  Created by Антон Текутов on 10.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

struct MenuRow {
    var title: String
    var action: () -> Void
}
struct MenuModule {
    var title: String
    var actions = [MenuRow]()
}

class SettingsPresenter: SettingsPresenterProtocol {

    var view: SettingsViewProtocol?
    var interactor: SettingsInteractorProtocol!
    var router: SettingsRouterProtocol!
    
    var menu = [MenuModule]()
    
    init() {
        var accountManagementModule = MenuModule(title: NSLocalizedString("Account management", comment: ""))
        accountManagementModule.actions.append(MenuRow(title: NSLocalizedString("Edit pofile", comment: ""), 
                                                       action: { self.router.showProfileEditor() }))
        accountManagementModule.actions.append(MenuRow(title: NSLocalizedString("LogOut", comment: ""), 
                                                       action: { 
                                                        self.interactor.clearUserData()
                                                        self.router.showAuthenticationScreen() }))
        menu.append(accountManagementModule)
    }
    
    func viewDidLoad() {

    }
    
    func getMenu() -> [MenuModule] {
        return menu
    }
}
