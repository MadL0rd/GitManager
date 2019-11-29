//
//  ReposPageProtocols.swift
//  GitManager
//
//  Created by Антон Текутов on 28.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

protocol ReposPageViewProtocol {
    var presenter:  ReposPagePresenterProtocol?     { get set }
    
    func showRepository(_ repository: Repository)
    func changeStarredStatus()
    func setReadme(base: String)
}

protocol ReposPagePresenterProtocol {
    var view:       ReposPageViewProtocol?          { get set }
    var interactor: ReposPageInteractorProtocol?    { get set }
    var router:     ReposPageRouterProtocol?        { get set }
    var repository: Repository?                     { get set }
    
    func viewDidLoad()
    func setUser(user : GitUser)
    func watchIssues()
    func changeViewStarredStatus()
    func starRepository()
    func setReadme(base: String)
}

protocol ReposPageInteractorProtocol {
    var presenter:      ReposPagePresenterProtocol?         { get set }
    var apiService:     GitHubApiServiceProtocol?           { get set }
    var starredService: StarredRepositoryServiceProtocol?   { get set }
    
    func getUser(login: String)
    func starRepository(_ repository: Repository)
}

protocol ReposPageRouterProtocol {
    var presenter:  ReposPagePresenterProtocol?     { get set }
    
    func showIssues(_ repository: Repository)
}
