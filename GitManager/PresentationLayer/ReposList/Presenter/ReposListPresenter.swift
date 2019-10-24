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
    
    func viewDidLoad() {
        self.loadReposList()
    }
    
    func loadReposList() {
        interactor?.getReposList()
    }
    
    func getItemsCount() -> Int {
        return repositoryList.count
    }
    
    func getItemWithIndex(index: Int) -> Repository? {
        if index >= 0 && index <= repositoryList.count {
            return repositoryList[index]
        }else {
            return nil
        }
    }
    
    func reposListDidFetch(repositories: [Repository]) {
        repositoryList = repositories
        view?.showReposList()
    }
}
