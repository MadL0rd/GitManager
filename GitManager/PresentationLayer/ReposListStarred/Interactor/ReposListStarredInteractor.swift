//
//  ReposListStarredInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 08.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposListStarredInteractor: ReposListInteractor, ReposListStarredInteractorProtocol {
    
    var presenterStarred: ReposListStarredPresenterProtocol?
    
    override func getReposList(){
        apiService?.getStarredRepositories(itemsPerPage: itemsPerPage, pageNumber: lastDownloadedPage, callback: self.setReposList(repositories:))
    }
    
    override func loadNextPage() {
        canDownloadMoreContent = false
        lastDownloadedPage += 1
        apiService?.getStarredRepositories(itemsPerPage: itemsPerPage, pageNumber: lastDownloadedPage, callback: self.setNextPageRepositories(repositories:))
    }
    
    /*internal override func starredCallback(starredRepos: Repository?){
        if let repos = starredRepos{
            if repos.starred == false && repositoryList?.first(where: {$0.id == repos.id}) == nil{
                repositoryList?.append(repos)
                presenter?.setReposCache(repositories: repositoryList ?? [])
                presenter?.showRepositories()
            }
            if let index = repositoryList?.firstIndex(where: {$0.id == repos.id}){
                repositoryList?[index].starred.toggle()
            }
            presenter?.refreshRepositoryStar(repository: repos)
        }
    }*/
}
