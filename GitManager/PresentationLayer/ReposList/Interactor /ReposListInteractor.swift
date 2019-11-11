//
//  ReposItemListInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 16.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit


class ReposListInteractor: ReposListInteractorProtocol {
    
    var starredService: StarredRepositoryServiceProtocol?
    var presenter: ReposListPresenterProtocol?
    var apiService: GitHubApiServiceProtocol?
    var repositoryList: [Repository]?
    private var repositoriesDownloaded = false
    private var viewLoaded = false
    private let reposDownloadCheckSerialQueue = DispatchQueue(label: "reposDownloadCheckSerialQueue", qos: .userInitiated)
    
    
    func getReposList(){
        apiService?.getRepositories(callback: self.setReposList(repositories:))
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
    
    private func sendReposList() {
        presenter?.showRepositories()
        starredService?.subscribeOnUpdate(refreshReposFunc: starredCallback(starredRepos:))
    }
    
    private func starredCallback(starredRepos: Repository?){
        if let repos = starredRepos{
            if repositoryList?.first(where: {$0.id == repos.id}) != nil{
                presenter?.refreshRepositoryStar(repository: repos)
            }
        }
    }
}
