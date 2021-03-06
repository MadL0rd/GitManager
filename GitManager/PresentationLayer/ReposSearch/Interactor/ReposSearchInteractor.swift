//
//  ReposSearchInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 14.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class ReposSearchInteractor: ReposListInteractor, ReposSearchInteractorProtocol {
    
    var presenterSearch: ReposSearchPresenterProtocol?
    private var currentQuery = ""
    private var currentQueryLanguage = ""
    
    override func getReposList(){
        canDownloadMoreContent = false
        lastDownloadedPage = 1
        apiService?.searchRepositories(name: currentQuery, language: currentQueryLanguage, itemsPerPage: itemsPerPage, pageNumber: lastDownloadedPage, callback: self.setReposList(repositories:))
    }
    
    override func loadNextPage() {
        canDownloadMoreContent = false
        lastDownloadedPage += 1
        apiService?.searchRepositories(name: currentQuery, language: currentQueryLanguage, itemsPerPage: itemsPerPage, pageNumber: lastDownloadedPage, callback: self.setNextPageRepositories(repositories:))
    }
    
    override func applySearchFilter(text: String) {
        currentQuery = text
        getReposList()
    }
    
    override func applyFilters(filtrationManager: FiltrationManagerProtocol?){
        guard var reposCache = repositoryList else { return }
        if let filers = filtrationManager{
            filterManagerBuff = filtrationManager
            if let language = filers.getStringParameterState(name: "Language", groupTitle: "Additional query parameters"){
                if currentQueryLanguage != language {
                    currentQueryLanguage = language
                    getReposList()
                    return
                }
            }
            if let languages = filers.getAllTagParametersState()["Languages"]{
                reposCache = reposCache.filter({
                    return (languages[$0.language ?? ""] ?? false)
                })
            }
        }else{
            if let filers = filterManagerBuff{
                if let languages = filers.getAllTagParametersState()["Languages"]{
                    reposCache = reposCache.filter({
                        return (languages[$0.language ?? ""] ?? false)
                    })
                }
            }
        }
        presenter?.setReposCache(repositories: reposCache)
        presenter?.showRepositories()
    }
    
    override func sendReposList() {
        if !haveSubscribtion {
            starredService?.subscribeOnUpdate(refreshReposFunc: starredCallback(starredRepos:), loadingCompleted: starredDownloadComplete)
            haveSubscribtion = true
        }else{
            if let reposList = repositoryList{
                repositoryList = starredService?.oneTimeUpdate(repositoriesToRefresh: reposList) ?? reposList
            }
        }
        if repositoryList?.count ?? 0 > itemsPerPage{
            refreshFilters()
        }else{
            setFilters()
        }
        applyFilters(filtrationManager: nil)
    }
    
    private func refreshFilters(){
        guard let repositories = repositoryList else { return }
        var filters = Set<String>()
        for repos in repositories{
            if let language = repos.language{
                filters.insert(language)
            }
        }
        presenterSearch?.refreshFiltersText(filters: Array(filters).sorted())
    }
}
