//
//  ReposPageInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 29.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class ReposPageInteractor: ReposPageInteractorProtocol {
    
    var starredService: StarredRepositoryServiceProtocol?
    var presenter: ReposPagePresenterProtocol?
    var apiService: GitHubApiServiceProtocol?
    
    func starRepository(_ repository: Repository) {
        starredService?.starRepository(repository)
    }
    
    func getUser(login: String) {
        starredService?.subscribeOnUpdate(refreshReposFunc: starredCallback(repository:), loadingCompleted: {})
        apiService?.getPublicUserInfo(login: login, callback: setUser(user:))
        if let repos = presenter?.repository{
            apiService?.getReadme(repository: repos, callback: setReadme(base:))
        }
    }
    
    private func setUser(user: GitUser){
        presenter?.setUser(user: user)
    }
    
    private func starredCallback(repository : Repository){
        if repository.id == presenter?.repository?.id {
            presenter?.changeViewStarredStatus()
        }
    }
    
    private func setReadme(base: String?){
        guard let readme = base else { return }
        presenter?.setReadme(base: readme)
    }
}
