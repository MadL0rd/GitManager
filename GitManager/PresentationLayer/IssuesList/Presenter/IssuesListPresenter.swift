//
//  IssuesListPresenter.swift
//  GitManager
//
//  Created by Антон Текутов on 06.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class IssuesListPresenter: IssuesListPresenterProtocol, SearchControllerOwnerProtocol {
    
    var view: IssuesListViewProtocol?
    var interactor: IssuesListInteractorProtocol?
    var router: IssuesListRouterProtocol?
    
    private var issuesCache = [Issue]()
    
    func viewDidLoad() {

    }
    
    func openIssuePage(index: Int) {
        
    }
    
    func getItemsCount() -> Int {
        return issuesCache.count
    }
    
    func getItemWithIndex(index: Int) -> Issue? {
        if index >= 0 && index < issuesCache.count {
            return issuesCache[index]
        }else {
            print("try to get access by incorrect index")
            return nil
        }
    }
    
    func showIssuePage(index: Int) {
        if index >= 0 && index < issuesCache.count {
            router?.openIssuePage(issue: issuesCache[index])
        }else {
            print("try to get access by incorrect index")
        }
    }
    
    func showIssues() {
        view?.showIssuesList()
    }
    
    func setFiltersText(filters: [String]) {
        
    }
    
    func applyFilters(filtrationManager: FiltrationManagerProtocol) {
        interactor?.applyFilters(filtrationManager: filtrationManager)
    }
    
    func setIssuesCache(issues: [Issue]) {
        issuesCache = issues
    }
    
    func loadNextPage() {
        interactor?.loadNextPage()
        view?.hideFooterButton()
    }
    
    func hideLoadingView() {
        
    }
    
    func searchTextChanged(text: String) {
        interactor?.applySearchFilter(text: text)
    }
    
    func scopeButtonPressed(text: String) {
        
    }
    
    func filterButtonPressed() {
        
    }
    
    func reloadData(){
        interactor?.getIssuesList()
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
    
    func createIssue(title: String) {
        interactor?.createIssue(title: title)
    }
    
    func searchBarStartMoving() {
        
    }
}

