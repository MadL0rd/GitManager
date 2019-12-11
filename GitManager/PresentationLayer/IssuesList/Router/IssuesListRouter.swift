//
//  IssuesListRouter.swift
//  GitManager
//
//  Created by Антон Текутов on 06.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class IssuesListRouter: IssuesListRouterProtocol , DependentRouterProtocol {
    
    var presenter: IssuesListPresenterProtocol?
    var mainRouter: ScreensRouterProtocol

    init(_ screensRouter: ScreensRouterProtocol) {
        mainRouter = screensRouter
    }
    
    static func createModule(screensRouter: ScreensRouterProtocol, content: AnyObject?) -> UIViewController {
        let view = IssuesListViewController()
        let presenter = IssuesListPresenter()
        let interactor = IssuesListInteractor()
        let router = IssuesListRouter(screensRouter)
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter
        interactor.apiService = AppConfig.GitService
        interactor.starredService = AppConfig.StarredService
        interactor.repository = content as? Repository
        
        router.presenter = presenter

        return view
    }
    
    func openIssuePage(issue: Issue) {
        
    }
}
