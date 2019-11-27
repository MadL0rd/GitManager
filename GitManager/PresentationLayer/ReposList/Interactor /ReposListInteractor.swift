//
//  ReposItemListInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 16.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposListInteractor: ReposListInteractorProtocol {
    
    var starredService: StarredRepositoryServiceProtocol?
    var presenter: ReposListPresenterProtocol?
    var apiService: GitHubApiServiceProtocol?
    var repositoryList: [Repository]?
    
    internal var repositoriesDownloaded = false
    internal var viewLoaded = false
    internal let reposDownloadCheckSerialQueue = DispatchQueue(label: "reposDownloadCheckSerialQueue", qos: .userInitiated)
    
    internal var filterManagerBuff : FiltrationManagerProtocol?
    internal var searchText = ""
    internal var haveSubscribtion = false
    internal var lastDownloadedPage = 1
    internal var itemsPerPage = 15
    internal var canDownloadMoreContent = false
    
    func getReposList(){
        apiService?.getRepositories(itemsPerPage: itemsPerPage, pageNumber: lastDownloadedPage, callback: self.setReposList(repositories:))
    }
    
    func loadNextPage() {
        canDownloadMoreContent = false
        lastDownloadedPage += 1
        apiService?.getRepositories(itemsPerPage: itemsPerPage, pageNumber: lastDownloadedPage, callback: self.setNextPageRepositories(repositories:))
    }
    
    func viewDidLoad() {
        reposDownloadCheckSerialQueue.sync {
            viewLoaded = true
            if repositoriesDownloaded && viewLoaded{
                sendReposList()
            }
        }
    }
    
    func starRepository(repository: Repository) {
        starredService?.starRepository(repository)
    }
    
    func applySearchFilter(text: String) {
        searchText = text
        applyFilters(filtrationManager: nil)
    }
    
    func applyFilters(filtrationManager: FiltrationManagerProtocol?){
        guard var reposCache = repositoryList else { return }
        if let filers = filtrationManager{
            filterManagerBuff = filtrationManager
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
        if searchText != ""{
            reposCache = reposCache.filter({
                return $0.name.lowercased().contains(searchText.lowercased())
            })
        }
        presenter?.setReposCache(repositories: reposCache)
        presenter?.showRepositories()
    }
    
    func getMoreContentDawnloadPossibility() -> Bool {
        return canDownloadMoreContent
    }
    
    internal func setNextPageRepositories(repositories : [Repository]){
        if repositories.count < itemsPerPage{
            canDownloadMoreContent = false
        }else{
            canDownloadMoreContent = true
        }
        let repositoriesBuff = starredService?.oneTimeUpdate(repositoriesToRefresh: repositories) ?? repositories
        if repositoryList == nil{
            repositoryList = repositoriesBuff
        }else{
            for item in repositoriesBuff{
                repositoryList?.append(item)
            }
        }
        sendReposList()
    }
    
    internal func setReposList(repositories : [Repository]){
        reposDownloadCheckSerialQueue.sync {
            if repositories.count < itemsPerPage{
                canDownloadMoreContent = false
            }else{
                canDownloadMoreContent = true
            }
            repositoryList = repositories
            repositoriesDownloaded = true
            if repositoriesDownloaded && viewLoaded{
                sendReposList()
            }
        }
    }
    
    internal func sendReposList() {
        if !haveSubscribtion {
            starredService?.subscribeOnUpdate(refreshReposFunc: starredCallback(starredRepos:))
            haveSubscribtion = true
        }else{
            if let reposList = repositoryList{
                repositoryList = starredService?.oneTimeUpdate(repositoriesToRefresh: reposList) ?? reposList
            }
        }
        setFilters()
        applyFilters(filtrationManager: nil)
    }
    
    internal func setFilters(){
        guard let repositories = repositoryList else { return }
        var filters = Set<String>()
        for repos in repositories{
            if let language = repos.language{
                filters.insert(language)
            }
        }
        presenter?.setFiltersText(filters: Array(filters).sorted())
    }
    
    internal func starredCallback(starredRepos: Repository?){
        if let repos = starredRepos{
            if repositoryList?.first(where: {$0.id == repos.id}) != nil{
                if let index = repositoryList?.firstIndex(where: {$0.id == repos.id}){
                    repositoryList?[index].starred.toggle()
                }
                presenter?.refreshRepositoryStar(repository: repos)
            }
        }
    }
}
