//
//  IssuePageRouter.swift
//  GitManager
//
//  Created by Антон Текутов on 13.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class IssuePageRouter: IssuePageRouterProtocol, DependentRouterProtocol {
    var presenter: IssuePagePresenterProtocol?
    
    init(_ screensRouter: ScreensRouterProtocol) {
        mainRouter = screensRouter
    }
    
    var mainRouter: ScreensRouterProtocol
    
    static func createModule(screensRouter: ScreensRouterProtocol, content: AnyObject?) -> UIViewController {
        let view = IssuePageViewController()
        let presenter = IssuePagePresenter()
        let interactor = IssuePageInteractor()
        let router = IssuePageRouter(screensRouter)
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter
        interactor.apiService = AppConfig.GitService
        interactor.issueBuff = content as? Issue
        
        router.presenter = presenter

        return view
    }
}
