//
//  ReposListPresenter.swift
//  GitManager
//
//  Created by Антон Текутов on 16.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class ReposListPresenter: ReposListPresenterProtocol, ReposTableViewerOwnerProtocol, ReposSearchControllerOwnerProtocol {
    
    var router: ReposListRouterProtocol?
    var view: ReposListViewProtocol?
    var interactor: ReposListInteractorProtocol?
    
    private var repositoriesCache = [Repository]()
    
    func viewDidLoad() {
        interactor?.viewDidLoad()
    }
    
    func getItemsCount() -> Int {
        return repositoriesCache.count
    }
    
    func reliadCells(indexBegin : Int, indexEnd : Int){
        for index in indexBegin...indexEnd {
            view?.reloadCellWithIndex(index: index)
        }
    }
    
    func getItemWithIndex(index: Int) -> Repository? {
        if index >= 0 && index < repositoriesCache.count {
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
            view?.reloadCellWithIndex(index: index)
        }
    }
    
    func setFiltersText(filters: [String]){
        view?.setFiltersText(filters: filters)
    }
    
    func applyFilters(filtrationManager: FiltrationManagerProtocol){
        interactor?.applyFilters(filtrationManager: filtrationManager)
    }
    
    func setReposCache(repositories: [Repository]) {
        repositoriesCache = repositories
    }
    func scrollContentEnds() {
        if interactor?.getMoreContentDawnloadPossibility() ?? false{
            view?.showFooterButton()
        }
    }
    func scrollContentNotEnds() {
        if interactor?.getMoreContentDawnloadPossibility() ?? false{
            view?.hideFooterButton()
        }
    }
    
    func loadNextPage() {
        interactor?.loadNextPage()
        view?.hideFooterButton()
    }
    
    func scopeButtonPressed(text: String) {

    }
    
    func filterButtonPressed(){
        view?.filterationManagerDisplaingChange()
    }
    
    func searchTextChanged(text : String){
        interactor?.applySearchFilter(text: text)
    }
}
