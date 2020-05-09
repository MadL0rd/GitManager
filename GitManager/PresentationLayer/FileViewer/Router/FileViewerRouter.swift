//
//  FileViewerRouter.swift
//  GitManager
//
//  Created by Антон Текутов on 06.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

class FileViewerRouter: FileViewerRouterProtocol, DependentRouterProtocol {
    
    var mainRouter: ScreensRouterProtocol
    var presenter: FileViewerPresenterProtocol?
    
    init(_ screensRouter: ScreensRouterProtocol) {
        mainRouter = screensRouter
    }
    
    static func createModule(screensRouter: ScreensRouterProtocol, content: AnyObject? = nil) -> UIViewController {
        let view = FileViewerViewController()
        let presenter = FileViewerPresenter()
        let interactor = FileViewerInteractor()
        let router = FileViewerRouter(screensRouter)
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router

        interactor.presenter = presenter
        interactor.gitApi = GitHubApiService()
        
        if let content = content as? (repo: Repository, path: String) {
            presenter.path = content.path
            presenter.repository = content.repo
        }
        
        return view
    }
}

