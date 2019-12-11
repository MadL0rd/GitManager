//
//  IssuesListProtocols.swift
//  GitManager
//
//  Created by Антон Текутов on 06.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

protocol IssuesListViewProtocol {
    var presenter:  IssuesListPresenterProtocol?     { get set }
    
    func showIssuesList()
    func setFiltersText(filters: [String])
    func showFooterButton()
    func hideFooterButton()
    func hideLoadingView()
    func filterationManagerDisplaingChange()
}

protocol IssuesListPresenterProtocol {
    var view:       IssuesListViewProtocol?          { get set }
    var interactor: IssuesListInteractorProtocol?    { get set }
    var router:     IssuesListRouterProtocol?        { get set }
    
    func viewDidLoad()
    func openIssuePage(index: Int)
    func getItemsCount() -> Int
    func getItemWithIndex(index: Int) -> Issue?
    func showIssuePage(index: Int)
    func showIssues()
    func setFiltersText(filters: [String])
    func applyFilters(filtrationManager: FiltrationManagerProtocol)
    func setIssuesCache(issues : [Issue])
    func loadNextPage()
    func hideLoadingView()
    func reloadData()
}

protocol IssuesListInteractorProtocol {
    var presenter:      IssuesListPresenterProtocol?        { get set }
    var apiService:     GitHubApiServiceProtocol?           { get set }
    var starredService: StarredRepositoryServiceProtocol?   { get set }
    var repository:     Repository?                         { get set }
    
    func getIssuesList()
    func getMoreContentDawnloadPossibility() -> Bool
    func loadNextPage()
    func applyFilters(filtrationManager: FiltrationManagerProtocol?)
    func applySearchFilter(text : String)
}

protocol IssuesListRouterProtocol {
    var presenter:  IssuesListPresenterProtocol?     { get set }
    
    func openIssuePage(issue: Issue)
}
