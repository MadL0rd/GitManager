//
//  ReposListStarredInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 08.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposListStarredInteractor: ReposListStarredInteractorProtocol {
    
    var repositoryList: [Repository]?
    var starredService: StarredRepositoryServiceProtocol?
    var presenter: ReposListStarredPresenterProtocol?
    var apiService: GitHubApiServiceProtocol?
    
    private var repositoriesDownloaded = false
    private var viewLoaded = false
    private let reposDownloadCheckSerialQueue = DispatchQueue(label: "reposDownloadCheckSerialQueue", qos: .userInitiated)
       
    func getReposList(){
        apiService?.getStarredRepositories(callback: self.setReposList(repositories:))
    }
    
    func setReposList(repositories : [Repository]){
        reposDownloadCheckSerialQueue.sync {
            repositoryList = repositories
            presenter?.repositoriesCache = repositories
            repositoriesDownloaded = true
            if repositoriesDownloaded && viewLoaded{
                sendReposList()
            }
        }
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
    
    func applyFilters(text: String?, language: String) {
        guard var reposCache = repositoryList else { return }
        if let textFilter = text{
            reposCache = reposCache.filter({
                if language != "All" && $0.language != language{
                    return false
                }
                return text == nil || $0.name.lowercased().contains(textFilter)
            })
        }else{
            reposCache = reposCache.filter({
                return language == "All" || $0.language == language
            })
        }
        presenter?.repositoriesCache = reposCache
        presenter?.showRepositories()
    }
    
    private func sendReposList() {
        presenter?.showRepositories()
        starredService?.subscribeOnUpdate(refreshReposFunc: starredCallback(starredRepos:))
        setFilters()
    }
    
    private func setFilters(){
        guard let repositories = repositoryList else { return }
        var filters = Set<String>()
        filters.insert("All")
        for repos in repositories{
            if let language = repos.language{
                filters.insert(language)
            }
        }
        
        presenter?.setFuletrsText(filters: Array(filters).sorted())
    }
    
    private func starredCallback(starredRepos: Repository?){
        if let repos = starredRepos{
            if repos.starred == false && repositoryList?.first(where: {$0.id == repos.id}) == nil{
                repositoryList?.append(repos)
                presenter?.repositoriesCache.append(repos)
                presenter?.showRepositories()
            }
            if let index = repositoryList?.firstIndex(where: {$0.id == repos.id}){
                repositoryList?[index].starred.toggle()
            }
            presenter?.refreshRepositoryStar(repository: repos)
        }
    }
}
