//
//  FileViewerPresenter.swift
//  GitManager
//
//  Created by Антон Текутов on 06.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

class FileViewerPresenter: FileViewerPresenterProtocol {

    var view: FileViewerViewProtocol?
    var interactor: FileViewerInteractorProtocol!
    var router: FileViewerRouterProtocol!
    
    var repository: Repository!
    var path: String!
    
    func viewDidLoad() {
        interactor.getFileContent(repo: repository, 
                                  path: path, 
                                  callback: { [ weak self ] content in
                                    guard let self = self 
                                        else { return }
                                    self.view?.showFileContent(content ?? "")})
        let pathParts = path.split(separator: "/")
        if let fileName = pathParts.last {
            view?.setTitle(String(fileName))
        }
    }
    
    func getFileLink() -> String {
        let escapedPath = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        let urlRequest = "https://github.com/\(repository.fullName)/blob\(escapedPath)"
        return urlRequest
    }
}
