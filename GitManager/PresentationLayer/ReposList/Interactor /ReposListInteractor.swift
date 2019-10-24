//
//  ReposItemListInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 16.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import Foundation
import UIKit


class ReposListInteractor: ReposListInteractorProtocol {
    
    var presenter: ReposListPresenterProtocol?
    var apiService: GitHubApiServiceProtocol?
        
    func getReposList(){
        apiService?.getRepositories(callBack: self.sendReposList)
    }
    
    func sendReposList( repositories : [Repository]) {
        presenter?.reposListDidFetch(repositories: repositories)
    }
    
}
