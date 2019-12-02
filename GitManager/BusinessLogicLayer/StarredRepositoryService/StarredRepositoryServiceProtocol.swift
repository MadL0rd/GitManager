//
//  CommonStarredRepositoryStorageProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 11.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

protocol StarredRepositoryServiceProtocol : class {
    init(gitService : GitHubApiServiceProtocol) 
    func getAllStarredRepositories()-> [Repository]?
    func subscribeOnUpdate(refreshReposFunc : @escaping(_ repos : Repository) -> Void)
    func oneTimeUpdate(repositoriesToRefresh: [Repository])->[Repository]
    func starRepository(_ repository : Repository)
}
