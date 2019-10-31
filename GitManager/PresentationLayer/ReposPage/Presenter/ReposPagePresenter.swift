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
    var repos: Repository?
    
    func viewDidLoad() {
        view?.showRepository(repos)
    }
    
    func watchIssues() {
        
    }
    
    
}
