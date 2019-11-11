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
    func repoladCellWithIndex(index: Int)
}

protocol ReposListPresenterProtocol: class {
    var interactor: ReposListInteractorProtocol?    { get set }
    var view:       ReposListViewProtocol?          { get set }
    var router:     ReposListRouterProtocol?        { get set }
    var repositoriesCache: [Repository]             { get set }
    
    func viewDidLoad()
    func getItemsCount() -> Int
    func getItemWithIndex(index: Int) -> Repository?
    func showProfileEditor()
    func showRepositoryPage(index: Int)
    func starRepository(index: Int)
    func refreshRepositoryStar(repository: Repository)
    func showRepositories()
}

protocol ReposListInteractorProtocol: class {
    var presenter:  ReposListPresenterProtocol?           { get set }
    var apiService: GitHubApiServiceProtocol?             { get set }
    var starredService: StarredRepositoryServiceProtocol? { get set }
    var repositoryList: [Repository]?                     { get set }
    
    func getReposLists()
    func sendReposList(repositories : [Repository])
    func starRepository(repository: Repository)
}

protocol ReposListRouterProtocol: class {
    func pushProfileEditor()
    func pushReposPage(repository: Repository)
}

