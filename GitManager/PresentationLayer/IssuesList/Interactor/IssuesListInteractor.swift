//
//  IssuesListInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 06.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class IssuesListInteractor: IssuesListInteractorProtocol {
    
    var presenter: IssuesListPresenterProtocol?
    var starredService: StarredRepositoryServiceProtocol?
    var apiService: GitHubApiServiceProtocol? {
        didSet {
            getIssuesList()
        }
    }
    var repository: Repository? {
        didSet {
            getIssuesList()
        }
    }
    private var issuesList = [Issue]()
    private var lastDownloadedPage = 1
    private var itemsPerPage = 15
    private var canDownloadMoreContent = false
    private var filterManagerBuff : FiltrationManagerProtocol?
    internal var searchText = ""
    
    func getIssuesList() {
        guard let repo = repository, apiService != nil else { return }
        lastDownloadedPage = 1
        canDownloadMoreContent = false
        apiService?.getIssues(repository: repo, itemsPerPage: itemsPerPage, pageNumber: lastDownloadedPage, callback: setIssues(issues:))
    }
    
    func loadNextPage() {
        guard let repo = repository, apiService != nil else { return }
        lastDownloadedPage += 1
        canDownloadMoreContent = false
        apiService?.getIssues(repository: repo, itemsPerPage: itemsPerPage, pageNumber: lastDownloadedPage, callback: setIssuesNextPage(issues:))
    }
    
    private func setIssues(issues: [Issue]){
        if issues.count < itemsPerPage{
            canDownloadMoreContent = false
        }else{
            canDownloadMoreContent = true
        }
        issuesList = issues
        applyFilters(filtrationManager: nil)
    }
    
    private func setIssuesNextPage(issues: [Issue]){
        if issues.count < itemsPerPage{
            canDownloadMoreContent = false
        }else{
            canDownloadMoreContent = true
        }
        for item in issues{
            issuesList.append(item)
        }
        applyFilters(filtrationManager: nil)
    }
    
    func getMoreContentDawnloadPossibility() -> Bool {
        return canDownloadMoreContent
    }
    
    func applyFilters(filtrationManager: FiltrationManagerProtocol?) {
        var issuesCache = issuesList
        if let filers = filtrationManager{
            filterManagerBuff = filers
        }
        if  let states = filterManagerBuff?.getAllTagParametersState()["State"],
            let open = states["Open"], let closed = states["Closed"] {
            if open != closed {
                if open {
                    issuesCache = issuesCache.filter({
                        return $0.open
                    })
                } else {
                    issuesCache = issuesCache.filter({
                        return $0.open == false
                    })
                }
            } else {
                if open == false {
                    issuesCache.removeAll()
                }
            }
        }
        if searchText != ""{
            issuesCache = issuesCache.filter({
                if $0.title.lowercased().contains(searchText.lowercased()) {
                    return true
                }
                if $0.user?.login?.lowercased().contains(searchText.lowercased()) ?? false {
                    return true
                }
                return false
            })
        }
        
        presenter?.setIssuesCache(issues: issuesCache)
        presenter?.showIssues()
    }
    
    func applySearchFilter(text: String) {
        searchText = text
        applyFilters(filtrationManager: nil)
    }
    
    func createIssue(title: String) {
        guard let repo = repository else { return }
        apiService?.createIssue(repository: repo, title: title, callback: setNewIssue(issue:))
    }
    
    private func setNewIssue(issue: Issue){
        issuesList.insert(issue, at: 0)
        applyFilters(filtrationManager: nil)
    }
}
