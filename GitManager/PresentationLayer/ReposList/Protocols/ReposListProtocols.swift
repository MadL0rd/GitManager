//
//  ReposListProtocols.swift
//  GitManager
//
//  Created by Антон Текутов on 16.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

protocol ReposListViewProtocol: class {
    var presenter:  ReposListPresenterProtocol?     { get set }
    
    func showReposList()
    func setFiltersText(filters: [String])
    func reloadCellWithIndex(index: Int)
}

protocol ReposListPresenterProtocol: class {
    var interactor: ReposListInteractorProtocol?    { get set }
    var view:       ReposListViewProtocol?          { get set }
    var router:     ReposListRouterProtocol?        { get set }
    
    func viewDidLoad()
    func getItemsCount() -> Int
    func getItemWithIndex(index: Int) -> Repository?
    func showProfileEditor()
    func showRepositoryPage(index: Int)
    func starRepository(index: Int)
    func refreshRepositoryStar(repository: Repository)
    func showRepositories()
    func setFuletrsText(filters: [String])
    func applyFilters(text : String?, language : String)
    func setReposCache(repositories : [Repository])
}

protocol ReposListInteractorProtocol: class {
    var presenter:  ReposListPresenterProtocol?      { get set }
    var apiService: GitHubApiServiceProtocol?               { get set }
    var starredService: StarredRepositoryServiceProtocol?   { get set }
    var repositoryList: [Repository]?                       { get set }
    
    func getReposList()
    func viewDidLoad()
    func starRepository(repository: Repository)
    func applyFilters(text : String?, language : String)
}

protocol ReposListRouterProtocol: class {
    func pushProfileEditor()
    func pushReposPage(repository: Repository)
}

