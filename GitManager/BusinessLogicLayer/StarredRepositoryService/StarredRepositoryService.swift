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
    
    required init(gitService: GitHubApiServiceProtocol) {
        gitHubApi = gitService
        gitHubApi.getStarredRepositories(callback: setStarredRepositories(repositories:))
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
        starredRepositories = repositories
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
