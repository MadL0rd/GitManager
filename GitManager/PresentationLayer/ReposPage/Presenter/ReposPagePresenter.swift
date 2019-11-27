//
//  ReposPagePresenter.swift
//  GitManager
//
//  Created by Антон Текутов on 29.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class ReposPagePresenter: ReposPagePresenterProtocol {
    
    var view: ReposPageViewProtocol?
    var interactor: ReposPageInteractorProtocol?
    var router: ReposPageRouterProtocol?
    var repository: Repository?
    
    func viewDidLoad() {
        interactor?.getUser(login: repository?.owner?.login ?? "")
    }
    
    func watchIssues() {
        
    }
    
    func setUser(user: GitUser) {
        repository?.owner = user
        guard let repos = repository else { return }
        view?.showRepository(repos)
    }
    
    func starRepository() {
        if let repo = repository{
            interactor?.starRepository(repo)
        }
    }
    
    func changeViewStarredStatus() {
        view?.changeStarredStatus()
    }
}
