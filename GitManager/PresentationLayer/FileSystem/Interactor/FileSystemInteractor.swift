//
//  FileSystemInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 05.04.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import Foundation

class FileSystemInteractor: FileSystemInteractorProtocol {
    
    var presenter:  FileSystemPresenterProtocol!
    
    var gitApi: GitHubApiServiceProtocol!
    
    func getBranches(repo: Repository, callback: @escaping ([String]) -> Void) {
        gitApi.getBrancesList(repository: repo, callback: callback)
    }
    
    func getBranchRootDirectory(repo: Repository, branch: String, callback: @escaping (Directory) -> Void) {
        gitApi.getBranchRootDirectory(repo: repo, branch: branch, callback: callback)
    }
    
    func getDirectoryContent(dir: Directory, callback : @escaping(_ directories : [Directory])-> Void) {
        gitApi.getDirectoryContentByUrl(url: dir.url, callback: callback)
    }
}
