//
//  ReposSearchRouter.swift
//  GitManager
//
//  Created by Антон Текутов on 14.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposSearchRouter: ReposSearchRouterProtocol , DependentRouterProtocol {

    var mainRouter: ScreensRouterProtocol

    init(_ screensRouter: ScreensRouterProtocol) {
        mainRouter = screensRouter
    }
    
    static func createModule(screensRouter: ScreensRouterProtocol, content: AnyObject?) -> UIViewController {
        let view = ReposSearchViewController()
        let presenter = ReposSearchPresenter()
        let interactor = ReposSearchInteractor()
        let router = ReposSearchRouter(screensRouter)
        
        view.presenter = presenter
        view.presenterStarred = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        presenter.viewSearch = view
        presenter.interactorSearch = interactor
        presenter.routerSearch = router

        interactor.presenter = presenter
        interactor.presenterSearch = presenter
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
