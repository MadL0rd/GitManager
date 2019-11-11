//
//  ReposListStarredRouter.swift
//  GitManager
//
//  Created by Антон Текутов on 08.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposListStarredRouter: ReposListStarredRouterProtocol , DependentRouterProtocol {

    var mainRouter: ScreensRouterProtocol

    init(_ screensRouter: ScreensRouterProtocol) {
        mainRouter = screensRouter
    }
    
    static func createModule(screensRouter: ScreensRouterProtocol, content: AnyObject?) -> UIViewController {
        let view = ReposListStarredViewController()
        let presenter = ReposListStarredPresenter()
        let interactor = ReposListStarredInteractor()
        let router = ReposListStarredRouter(screensRouter)
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter
        interactor.apiService = AppConfig.GitService
        interactor.starredService = AppConfig.StarredService
        interactor.getReposList()
        
        return view
    }
    
    func pushProfileEditor() {
        mainRouter.pushNewScreenToCurrentNavigationController(ProfileEditorRouter.self)
    }
    
    func pushReposPage(repository: Repository) {
        mainRouter.pushNewScreenToCurrentNavigationController(ReposPageRouter.self, content: repository as AnyObject)
    }
}
