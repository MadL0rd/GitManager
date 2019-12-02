//
//  ReposListStarredInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 08.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposListStarredInteractor: ReposListInteractor, ReposListStarredInteractorProtocol {
    
    var presenterStarred: ReposListStarredPresenterProtocol?
    
    override func getReposList(){
        lastDownloadedPage = 1
        canDownloadMoreContent = false
        apiService?.getStarredRepositories(itemsPerPage: itemsPerPage, pageNumber: lastDownloadedPage, callback: self.setReposList(repositories:))
    }
    
    override func loadNextPage() {
        canDownloadMoreContent = false
        lastDownloadedPage += 1
        apiService?.getStarredRepositories(itemsPerPage: itemsPerPage, pageNumber: lastDownloadedPage, callback: self.setNextPageRepositories(repositories:))
    }
}
