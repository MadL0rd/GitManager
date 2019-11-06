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
    
    var repositoryList = [Repository]()
    var starredRepositoryList = [Repository]()
    
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
    
    func showRepositories(){
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
    
    func refreshRepositoryStar(repository: Repository){
        if let index = repositoryList.firstIndex(where: {$0.id == repository.id}){
            repositoryList[index].starred.toggle()
            view?.repoladCellWithIndex(index: index)
        }
    }
}
