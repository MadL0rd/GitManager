//
//  FileSystemRouter.swift
//  GitManager
//
//  Created by Антон Текутов on 05.04.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

class FileSystemRouter: FileSystemRouterProtocol, DependentRouterProtocol {
    
    var mainRouter: ScreensRouterProtocol
    var presenter: FileSystemPresenterProtocol?
    
    init(_ screensRouter: ScreensRouterProtocol) {
        mainRouter = screensRouter
    }
    
    static func createModule(screensRouter: ScreensRouterProtocol, content: AnyObject?) -> UIViewController {
        let view = FileSystemViewController()
        let presenter = FileSystemPresenter()
        let interactor = FileSystemInteractor()
        let router = FileSystemRouter(screensRouter)
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        if let repo = content as? Repository {
            presenter.repository = repo
        }

        interactor.presenter = presenter
        interactor.gitApi = GitHubApiService()
        
        return view
    }
    
    func showFile(repo: Repository, path: String, dir: Directory) {
        let content = (repo: repo, path: path, dir: dir)
        mainRouter.pushNewScreenToCurrentNavigationController(FileViewerRouter.self, content: content as AnyObject)
    }
}

