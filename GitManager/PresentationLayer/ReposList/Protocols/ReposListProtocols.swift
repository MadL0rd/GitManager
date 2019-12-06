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
    func showFooterButton()
    func hideFooterButton()
    func hideLoadingView()
    func setScopeBottonsText(buttonsText: [String])
    func filterationManagerDisplaingChange()
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
    func setFiltersText(filters: [String])
    func applyFilters(filtrationManager: FiltrationManagerProtocol)
    func setReposCache(repositories : [Repository])
    func loadNextPage()
    func hideLoadingView()
}

protocol ReposListInteractorProtocol: class {
    var presenter:  ReposListPresenterProtocol?      { get set }
    var apiService: GitHubApiServiceProtocol?               { get set }
    var starredService: StarredRepositoryServiceProtocol?   { get set }
    var repositoryList: [Repository]?                       { get set }
    
    func getReposList()
    func getMoreContentDawnloadPossibility() -> Bool
    func viewDidLoad()
    func loadNextPage()
    func starRepository(repository: Repository)
    func applyFilters(filtrationManager: FiltrationManagerProtocol?)
    func applySearchFilter(text : String)
}

protocol ReposListRouterProtocol: class {
    func pushProfileEditor()
    func pushReposPage(repository: Repository)
}

