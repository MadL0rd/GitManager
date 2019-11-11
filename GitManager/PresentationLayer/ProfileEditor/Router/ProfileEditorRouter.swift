//
//  ProvileEditorRouter.swift
//  GitManager
//
//  Created by Антон Текутов on 28.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ProfileEditorRouter: ProfileEditorRouterProtocol , DependentRouterProtocol {

    var mainRouter: ScreensRouterProtocol

    init(_ screensRouter: ScreensRouterProtocol) {
        mainRouter = screensRouter
    }
    
    static func createModule(screensRouter: ScreensRouterProtocol, content: AnyObject?) -> UIViewController {
        let view = ProfileEditorView()
        let presenter = ProfileEditorPresenter()
        let interactor = ProfileEditorInteractor()
        let router = ProfileEditorRouter(screensRouter)
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter
        interactor.apiService = AppConfig.GitService
        interactor.keychain = KeychainService()

        return view
    }
    
    func showAuthenticationScreen(){
        mainRouter.showNewScreen(AuthenticationRouter.self)
    }
}

