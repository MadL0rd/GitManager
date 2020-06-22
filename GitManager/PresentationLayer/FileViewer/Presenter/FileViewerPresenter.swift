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
    var directory: Directory!
    
    func viewDidLoad() {
        interactor.getFileContent(dir: directory, 
                                  callback: representFileContent(_:))
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
    
    private func representFileContent(_ content: String?) {
        let pathParts = path.split(separator: "/")
        let fileName = pathParts.last
        let fileExtension = String(fileName?.split(separator: ".").last ?? "")
        view?.showFileContent(content, fileExtension: fileExtension)
    }
}
