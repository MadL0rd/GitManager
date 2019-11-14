//
//  ReposSearchInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 14.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class ReposSearchInteractor: ReposListInteractor, ReposSearchInteractorProtocol {
    
    var presenterStarred: ReposSearchPresenterProtocol?
    
    override func getReposList(){
        apiService?.searchRepositories(name: "kek", language: "kek", callback: self.setReposList(repositories:))
    }
}
