//
//  IssuesListInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 06.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class IssuesListInteractor: IssuesListInteractorProtocol {
    
    var presenter: IssuesListPresenterProtocol?
    var apiService: GitHubApiServiceProtocol? {
        didSet {
            getIssuesList()
        }
    }
    var starredService: StarredRepositoryServiceProtocol?
    var repository: Repository? {
        didSet {
            getIssuesList()
        }
    }
    
    func getIssuesList() {
        guard let repo = repository, apiService != nil else { return }
        apiService?.getIssues(repository: repo, itemsPerPage: 30, pageNumber: 1, callback: setIssues(issues:))
    }
    
    private func setIssues(issues: [Issue]?){
        if let cache = issues{
            presenter?.setIssuesCache(issues: cache)
            presenter?.showIssues()
        }
    }
    
    func getMoreContentDawnloadPossibility() -> Bool {
        return true
    }
    
    func loadNextPage() {
        
    }
    
    func applyFilters(filtrationManager: FiltrationManagerProtocol?) {
        
    }
    
    func applySearchFilter(text: String) {
        
    }
    
    
}
