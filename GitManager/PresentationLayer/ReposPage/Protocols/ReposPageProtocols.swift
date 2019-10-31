//
//  ReposPageProtocols.swift
//  GitManager
//
//  Created by Антон Текутов on 28.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

protocol ReposPageViewProtocol {
    var presenter:  ReposPagePresenterProtocol?     { get set }
    
    func showRepository(_ repository: Repository?)
}

protocol ReposPagePresenterProtocol {
    var view:       ReposPageViewProtocol?          { get set }
    var interactor: ReposPageInteractorProtocol?    { get set }
    var router:     ReposPageRouterProtocol?        { get set }
    var repos:      Repository?                     { get set }
    
    func viewDidLoad()
    func watchIssues()
}

protocol ReposPageInteractorProtocol {
    var presenter:  ReposPagePresenterProtocol?     { get set }
    var apiService: GitHubApiServiceProtocol?       { get set }
    
    func addToStarred(_ repository: Repository)
}

protocol ReposPageRouterProtocol {
    var presenter:  ReposPagePresenterProtocol?     { get set }
    
    func showIssues(_ repository: Repository)
}
