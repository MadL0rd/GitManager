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
    
    private var repositoriesDownloaded = false
    private var starredRepositoriesDownloaded = false
    private let reposDownloadCheckSerialQueue = DispatchQueue(label: "reposDownloadCheckSerialQueue", qos: .userInitiated)
        
    func getReposLists(){
        apiService?.getStarredRepositories(callback: self.sendStarredReposList)
        apiService?.getRepositories(callback: self.sendReposList)
    }
    
    func sendReposList(repositories : [Repository]) {
        presenter?.repositoryList = repositories
        reposDownloadCheckSerialQueue.sync {
            repositoriesDownloaded = true
            if repositoriesDownloaded && starredRepositoriesDownloaded{
                setStarredAndShowRepositories()
            }
        }
    }

    func sendStarredReposList(repositories : [Repository]) {
        presenter?.starredRepositoryList = repositories
        reposDownloadCheckSerialQueue.sync {
            starredRepositoriesDownloaded = true
            if repositoriesDownloaded && starredRepositoriesDownloaded{
                setStarredAndShowRepositories()
            }
        }
    }
    
    func starRepository(repository: Repository) {
        apiService?.starRepository(repository: repository, callback: starredCallback(starredRepos:))
    }
    
    private func starredCallback(starredRepos: Repository?){
        if let repos = starredRepos{
            presenter?.refreshRepositoryStar(repository: repos)
        }
    }
    
    private func setStarredAndShowRepositories(){
        guard let starred = presenter?.starredRepositoryList else { return }
        for item in starred {
            if let index = presenter?.repositoryList.firstIndex(where: {$0.id == item.id}){
                presenter?.repositoryList[index].starred = true
            }
        }
        presenter?.showRepositories()
    }
}
