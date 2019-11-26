//
//  ReposPageInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 29.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class ReposPageInteractor: ReposPageInteractorProtocol {
    
    var presenter: ReposPagePresenterProtocol?
    var apiService: GitHubApiServiceProtocol?
    
    func addToStarred(_ repository: Repository) {
        
    }
    
    func getUser(login: String) {
        apiService?.getPublicUserInfo(login: login, callback: setUser(user:))
    }
    
    private func setUser(user: GitUser){
        presenter?.setUser(user: user)
    }
}
