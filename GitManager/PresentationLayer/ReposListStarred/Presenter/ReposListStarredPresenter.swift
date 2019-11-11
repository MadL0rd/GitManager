//
//  ReposListStarredPresenter.swift
//  GitManager
//
//  Created by Антон Текутов on 08.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class ReposListStarredPresenter: ReposListStarredPresenterProtocol, ReposTableViewerOwnerProtocol {

    var router: ReposListStarredRouterProtocol?
    weak var view: ReposListStarredViewProtocol?
    var interactor: ReposListStarredInteractorProtocol?
    
    var repositoriesCache = [Repository]()
    
    func viewDidLoad() {
        interactor?.viewDidLoad()
    }
    
    func getItemsCount() -> Int {
        return repositoriesCache.count
    }
    
    func getItemWithIndex(index: Int) -> Repository? {
        if index >= 0 && index <= repositoriesCache.count {
            return repositoriesCache[index]
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

    func showRepositoryPage(index: Int){
        router?.pushReposPage(repository: repositoriesCache[index])
    }
    
    func starRepository(index: Int) {
        if let repos = getItemWithIndex(index: index){
            interactor?.starRepository(repository: repos)
        }
    }
    
    func refreshRepositoryStar(repository: Repository){
        if let index = repositoriesCache.firstIndex(where: {$0.id == repository.id}){
            repositoriesCache[index].starred.toggle()
            view?.repoladCellWithIndex(index: index)
        }
    }
}
