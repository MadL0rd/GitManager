//
//  CommonStarredRepositoryStorage.swift
//  GitManager
//
//  Created by Антон Текутов on 11.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class StarredRepositoryService: StarredRepositoryServiceProtocol {
    
    private let gitHubApi : GitHubApiServiceProtocol
    private var starredRepositories : [Repository]? = nil
    private var subscribers = [(Repository) -> Void]()
    
    private var lastDownloadedPage = 1
    private let itemsPerPage = 100
    
    required init(gitService: GitHubApiServiceProtocol) {
        gitHubApi = gitService
        gitHubApi.getStarredRepositories(itemsPerPage: itemsPerPage, pageNumber: lastDownloadedPage, callback: setStarredRepositories(repositories:))
    }
    
    func getAllStarredRepositories() -> [Repository]? {
        return starredRepositories
    }
    
    func subscribeOnUpdate(refreshReposFunc: @escaping (Repository) -> Void) {
        subscribers.append(refreshReposFunc)
        if let starred = starredRepositories {
            for repos in starred{
                refreshReposFunc(repos)
            }
        }
    }
    
    func oneTimeUpdate(repositoriesToRefresh: [Repository]) -> [Repository] {
        var repositories = [Repository]()
        for var repos in repositoriesToRefresh {
            if ((starredRepositories?.first(where: {$0.id == repos.id})) != nil) {
                repos.starred = true
            }
            repositories.append(repos)
        }
        return repositories
    }
    
    func starRepository(_ repository: Repository) {
        gitHubApi.starRepository(repository: repository, callback: calbackApiStarRequest(repos:))
        let starred = !repository.starred
        if starred{
            starredRepositories?.append(repository)
        }else {
            if let index = starredRepositories?.firstIndex(where: {$0.id == repository.id}){
                starredRepositories?.remove(at: index)
            }
        }
        for update in subscribers {
            update(repository)
        }
    }
    
    private func setStarredRepositories(repositories : [Repository]){
        
        if lastDownloadedPage == 1 {
            starredRepositories = repositories
        }else{
            for repos in repositories {
                starredRepositories?.append(repos)
            }
        }
        if repositories.count == itemsPerPage {
            lastDownloadedPage += 1
            gitHubApi.getStarredRepositories(itemsPerPage: itemsPerPage, pageNumber: lastDownloadedPage, callback: setStarredRepositories(repositories:))
        }
        for repos in repositories{
            for update in subscribers{
                update(repos)
            }
        }
    }
    
    private func calbackApiStarRequest(repos : Repository?){
        if repos == nil{
            print("bad response")
        }
    }
}
