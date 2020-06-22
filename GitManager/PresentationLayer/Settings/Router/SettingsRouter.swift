//
//  SettingsRouter.swift
//  GitManager
//
//  Created by Антон Текутов on 10.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

class SettingsRouter: SettingsRouterProtocol, DependentRouterProtocol {
    
    var mainRouter: ScreensRouterProtocol
    var presenter: SettingsPresenterProtocol?
    
    init(_ screensRouter: ScreensRouterProtocol) {
        mainRouter = screensRouter
    }
    
    static func createModule(screensRouter: ScreensRouterProtocol, content: AnyObject?) -> UIViewController {
        let view = SettingsViewController()
        let presenter = SettingsPresenter()
        let interactor = SettingsInteractor()
        let router = SettingsRouter(screensRouter)
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.keychain = KeychainService()
        interactor.presenter = presenter
        
        return view
    }
    
    func showProfileEditor() {
        mainRouter.pushNewScreenToCurrentNavigationController(ProfileEditorRouter.self)
    }
    
    func showAuthenticationScreen(){
        mainRouter.showNewScreen(AuthenticationRouter.self)
    }
}

