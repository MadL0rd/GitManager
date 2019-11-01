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
   
    var presenter: ReposListPresenterProtocol?
    var apiService: GitHubApiServiceProtocol?
        
    func getReposLists(){
        apiService?.getStarredRepositories(callback: self.sendStarredReposList)
        apiService?.getRepositories(callback: self.sendReposList)
    }
    
    func sendReposList(repositories : [Repository]) {
        presenter?.reposListDidFetch(repositories: repositories)
    }
    
    func sendStarredReposList(repositories : [Repository]) {
        presenter?.starredReposListDidFetch(repositories: repositories)
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
