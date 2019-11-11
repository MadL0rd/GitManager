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
        
    func getReposLists(){
        apiService?.getStarredRepositories(callback: self.sendStarredReposList)
    }

    func sendStarredReposList(repositories : [Repository]) {
        repositoryList = repositories
        presenter?.repositoriesCache = repositories
        presenter?.showRepositories()
        starredService?.subscribeOnUpdate(refreshReposFunc: starredCallback(starredRepos:))
    }
    
    func starRepository(repository: Repository) {
        starredService?.starRepository(repository)
    }
    
    private func starredCallback(starredRepos: Repository?){
        if let repos = starredRepos{
            if repos.starred == false && repositoryList?.first(where: {$0.id == repos.id}) == nil{
                repositoryList?.append(repos)
                presenter?.repositoriesCache.append(repos)
                presenter?.showRepositories()
            }
            presenter?.refreshRepositoryStar(repository: repos)
        }
    }
}
