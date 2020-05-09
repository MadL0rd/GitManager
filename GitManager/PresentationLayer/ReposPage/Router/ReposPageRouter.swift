//
//  ReposPageRouter.swift
//  GitManager
//
//  Created by Антон Текутов on 28.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposPageRouter: ReposPageRouterProtocol, DependentRouterProtocol {
    var presenter: ReposPagePresenterProtocol?
    
    init(_ screensRouter: ScreensRouterProtocol) {
        mainRouter = screensRouter
    }
    
    var mainRouter: ScreensRouterProtocol
    
    static func createModule(screensRouter: ScreensRouterProtocol, content: AnyObject?) -> UIViewController {
        let view = ReposPageViewController()
        let presenter = ReposPagePresenter()
        let interactor = ReposPageInteractor()
        let router = ReposPageRouter(screensRouter)
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        presenter.repository = content as? Repository

        interactor.presenter = presenter
        interactor.apiService = AppConfig.GitService
        interactor.starredService = AppConfig.StarredService
        
        router.presenter = presenter

        return view
    }
    
    func showIssues(_ repository: Repository) {
        mainRouter.pushNewScreenToCurrentNavigationController(IssuesListRouter.self, content: repository as AnyObject)
    }
    
    func showBranches(_ repository: Repository) {
        mainRouter.pushNewScreenToCurrentNavigationController(FileSystemRouter.self, content: repository as AnyObject)
    }
}
