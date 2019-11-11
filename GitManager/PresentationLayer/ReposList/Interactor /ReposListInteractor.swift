//
//  ReposItemListInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 16.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import Foundation
import UIKit


class ReposListInteractor: ReposListInteractorProtocol {
    
    var starredService: StarredRepositoryServiceProtocol?
    var presenter: ReposListPresenterProtocol?
    var apiService: GitHubApiServiceProtocol?
    var repositoryList: [Repository]?
    
    func getReposLists(){
        apiService?.getRepositories(callback: self.sendReposList)
    }
    
    func sendReposList(repositories : [Repository]) {
        presenter?.repositoriesCache = repositories
        presenter?.showRepositories()
        starredService?.subscribeOnUpdate(refreshReposFunc: starredCallback(starredRepos:))
    }
    
    func starRepository(repository: Repository) {
        starredService?.starRepository(repository)
    }
    
    private func starredCallback(starredRepos: Repository){
        presenter?.refreshRepositoryStar(repository: starredRepos)
    }
}
