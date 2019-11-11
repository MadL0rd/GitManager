//
//  CommonStarredRepositoryStorage.swift
//  GitManager
//
//  Created by Антон Текутов on 11.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class StarredRepositoryService: StarredRepositoryServiceProtocol {
    
    private static var starredRepositories : [Repository]? = {
        StarredRepositoryService.gitHubApi.getStarredRepositories(callback: setStarredRepositories(repositories:))
        return nil
    }()
    private static var subscribers = [(Repository) -> Void]()
    private static let gitHubApi : GitHubApiServiceProtocol = GitHubApiService()
    
    func getAllStarredRepositories() -> [Repository]? {
        return StarredRepositoryService.starredRepositories
    }
    
    func subscribeOnUpdate(refreshReposFunc: @escaping (Repository) -> Void) {
        StarredRepositoryService.subscribers.append(refreshReposFunc)
        if let starred = StarredRepositoryService.starredRepositories {
            for repos in starred{
                refreshReposFunc(repos)
            }
        }
        
    }
    
    func starRepository(_ repository: Repository) {
        StarredRepositoryService.gitHubApi.starRepository(repository: repository, callback: calbackApiStarRequest(repos:))
        let starred = !repository.starred
        if starred{
            StarredRepositoryService.starredRepositories?.append(repository)
        }else {
            if let index = StarredRepositoryService.starredRepositories?.firstIndex(where: {$0.id == repository.id}){
                StarredRepositoryService.starredRepositories?.remove(at: index)
            }
        }
        for update in StarredRepositoryService.subscribers {
            update(repository)
        }
    }
    
    private static func setStarredRepositories(repositories : [Repository]){
        StarredRepositoryService.starredRepositories = repositories
        for repos in repositories{
            for update in StarredRepositoryService.subscribers{
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
