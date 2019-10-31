//
//  ReposListPresenter.swift
//  GitManager
//
//  Created by Антон Текутов on 16.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import Foundation

class ReposListPresenter: ReposListPresenterProtocol {

    var router: ReposListRouterProtocol?
    weak var view: ReposListViewProtocol?
    var interactor: ReposListInteractorProtocol?
    
    private var repositoryList = [Repository]()
    private var repositoriesDownloaded = false
    private var starredRepositoryList = [Repository]()
    private var starredRepositoriesDownloaded = false
    
    func viewDidLoad() {
        interactor?.getReposLists()
    }
    
    func getItemsCount() -> Int {
        return repositoryList.count
    }
    
    func getItemWithIndex(index: Int) -> Repository? {
        if index >= 0 && index <= repositoryList.count {
            return repositoryList[index]
        }else {
            print("try to get access by incorrect index")
            return nil
        }
    }
    
    func reposListDidFetch(repositories: [Repository]) {
        repositoryList = repositories
        repositoriesDownloaded = true
        if starredRepositoriesDownloaded{
            setStarredAndShowRepositories()
        }
    }
    
    func starredReposListDidFetch(repositories: [Repository]) {
        starredRepositoryList = repositories
        starredRepositoriesDownloaded = true
        if repositoriesDownloaded{
            setStarredAndShowRepositories()
        }
    }
    
    private func setStarredAndShowRepositories(){
        for item in starredRepositoryList{
            if let index = repositoryList.firstIndex(where: {$0.id == item.id}){
                repositoryList[index].starred = true
            }
        }
        view?.showReposList()
    }
    
    func showProfileEditor() {
        router?.pushProfileEditor()
    }
    
    func showReposPageByItemIndex(index: Int){
        router?.pushReposPage(repository: repositoryList[index])
    }
    
    func starRepository(index: Int) {
        if let repos = getItemWithIndex(index: index){
            interactor?.starRepository(repository: repos)
        }
    }
    
    func refreshRepositoryStar(id: Int64){
        if let index = repositoryList.firstIndex(where: {$0.id == id}){
            repositoryList[index].starred = repositoryList[index].starred == true ? false : true
            view?.showReposList()
        }
    }
}
