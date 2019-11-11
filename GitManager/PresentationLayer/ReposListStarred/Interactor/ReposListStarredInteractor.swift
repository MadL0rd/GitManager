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
    
    private var repositoriesDownloaded = false
    private var viewLoaded = false
    private let reposDownloadCheckSerialQueue = DispatchQueue(label: "reposDownloadCheckSerialQueue", qos: .userInitiated)
       
        
    func getReposList(){
        apiService?.getStarredRepositories(callback: self.setReposList(repositories:))
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
            if repos.starred == false && repositoryList?.first(where: {$0.id == repos.id}) == nil{
                repositoryList?.append(repos)
                presenter?.repositoriesCache.append(repos)
                presenter?.showRepositories()
            }
            presenter?.refreshRepositoryStar(repository: repos)
        }
    }
}
