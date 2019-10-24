//
//  AuthenticationRouter.swift
//  GitManager
//
//  Created by Антон Текутов on 22.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//
import UIKit

class AuthenticationRouter: AuthenticationRouterProtocol, DependentRouterProtocol {
    
    var mainRouter: ScreensRouterProtocol
    
    init(screensRouter: ScreensRouterProtocol) {
        mainRouter = screensRouter
    }
    
    static func createModule(screensRouter: ScreensRouterProtocol) -> UIViewController {
        let view = AuthenticationViewController()
        let presenter = AuthenticationPresenter()
        let interactor = AuthenticationInteractor()
        let router = AuthenticationRouter(screensRouter: screensRouter)
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        interactor.apiService = GitHubApiService()
        
        return view
    }
    
    
    func pushMainScreen() {
        mainRouter.showNewScreen(creator: ReposListRouter.createModule(screensRouter: ), false)
    }
}
