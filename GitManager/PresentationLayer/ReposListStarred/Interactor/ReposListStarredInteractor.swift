//
//  ReposListStarredInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 08.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposListStarredInteractor: ReposListStarredInteractorProtocol {
   
    var presenter: ReposListStarredPresenterProtocol?
    var apiService: GitHubApiServiceProtocol?
        
    func getReposLists(){
        apiService?.getStarredRepositories(callback: self.sendStarredReposList)
    }

    func sendStarredReposList(repositories : [Repository]) {
        presenter?.repositoryList = repositories
        presenter?.showRepositories()
    }
    
    func starRepository(repository: Repository) {
        apiService?.starRepository(repository: repository, callback: starredCallback(starredRepos:))
    }
    
    private func starredCallback(starredRepos: Repository?){
        if let repos = starredRepos{
            presenter?.refreshRepositoryStar(repository: repos)
        }
    }
}
