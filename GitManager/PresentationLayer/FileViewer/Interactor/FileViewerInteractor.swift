//
//  FileViewerInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 06.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import Foundation

class FileViewerInteractor: FileViewerInteractorProtocol {
    
    var presenter:  FileViewerPresenterProtocol!
    
    var gitApi: GitHubApiServiceProtocol!
    
    func getFileContent(repo: Repository, path: String, callback: @escaping (String?) -> Void) {
        gitApi.getFileContent(repository: repo, path: path, callback: callback)
    }
}
