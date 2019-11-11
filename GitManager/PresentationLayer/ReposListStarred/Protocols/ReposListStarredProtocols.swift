//
//  ReposListStarredProtocols.swift
//  GitManager
//
//  Created by Антон Текутов on 08.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

protocol ReposListStarredViewProtocol: class {
    var presenter:  ReposListStarredPresenterProtocol?     { get set }
    
    func showReposList()
    func repoladCellWithIndex(index: Int)
}

protocol ReposListStarredPresenterProtocol: class {
    var interactor: ReposListStarredInteractorProtocol?    { get set }
    var view:       ReposListStarredViewProtocol?          { get set }
    var router:     ReposListStarredRouterProtocol?        { get set }
    var repositoriesCache: [Repository]                { get set }
    
    func viewDidLoad()
    func getItemsCount() -> Int
    func getItemWithIndex(index: Int) -> Repository?
    func showProfileEditor()
    func showRepositoryPage(index: Int)
    func starRepository(index: Int)
    func refreshRepositoryStar(repository: Repository)
    func showRepositories()
}

protocol ReposListStarredInteractorProtocol: class {
    var presenter:  ReposListStarredPresenterProtocol?      { get set }
    var apiService: GitHubApiServiceProtocol?               { get set }
    var starredService: StarredRepositoryServiceProtocol?   { get set }
    var repositoryList: [Repository]?                       { get set }
    
    func getReposLists()
    func sendStarredReposList(repositories : [Repository])
    func starRepository(repository: Repository)
}

protocol ReposListStarredRouterProtocol: class {
    func pushProfileEditor()
    func pushReposPage(repository: Repository)
}

