//
//  ReposListRouter.swift
//  GitManager
//
//  Created by Антон Текутов on 16.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposListRouter: ReposListRouterProtocol , DependentRouterProtocol {

    var mainRouter: ScreensRouterProtocol

    init(_ screensRouter: ScreensRouterProtocol) {
        mainRouter = screensRouter
    }
    
    static func createModule(screensRouter: ScreensRouterProtocol, content: AnyObject?) -> UIViewController {
        let view = ReposListView()
        let presenter = ReposListPresenter()
        let interactor = ReposListInteractor()
        let router = ReposListRouter(screensRouter)
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter
        interactor.apiService = GitHubApiService()
        
        return view
    }
    
    func pushProfileEditor() {
        mainRouter.pushNewScreenToNavigationController(ProfileEditorRouter.self)
    }
    
    func pushReposPage(repository: Repository) {
        mainRouter.pushNewScreenToNavigationController(ReposPageRouter.self, content: repository as AnyObject)
    }
}
