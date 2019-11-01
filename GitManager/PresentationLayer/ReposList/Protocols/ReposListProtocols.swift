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
}

protocol ReposListPresenterProtocol: class {
    var interactor: ReposListInteractorProtocol?    { get set }
    var view:       ReposListViewProtocol?          { get set }
    var router:     ReposListRouterProtocol?        { get set }
    
    func viewDidLoad()
    func getItemsCount() -> Int
    func getItemWithIndex(index: Int) -> Repository?
    func reposListDidFetch(repositories: [Repository])
    func starredReposListDidFetch(repositories: [Repository])
    func showProfileEditor()
    func showReposPageByItemIndex(index: Int)
    func starRepository(index: Int)
    func refreshRepositoryStar(repository: Repository)
}

protocol ReposListInteractorProtocol: class {
    var presenter:  ReposListPresenterProtocol?     { get set }
    var apiService: GitHubApiServiceProtocol?       { get set }
    
    func getReposLists()
    func sendReposList(repositories : [Repository])
    func sendStarredReposList(repositories : [Repository])
    func starRepository(repository: Repository)
}

protocol ReposListRouterProtocol: class {
    func pushProfileEditor()
    func pushReposPage(repository: Repository)
}

