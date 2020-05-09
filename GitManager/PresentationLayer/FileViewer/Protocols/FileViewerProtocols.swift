//
//  FileViewerProtocols.swift
//  GitManager
//
//  Created by Антон Текутов on 06.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

protocol FileViewerViewProtocol {
    
    var presenter: FileViewerPresenterProtocol! { get set }
    
    func showFileContent(_ htmlSource : String)
    func setTitle(_ title: String)
}

protocol FileViewerPresenterProtocol {
    
    var view: FileViewerViewProtocol? { get set }
    var interactor: FileViewerInteractorProtocol! { get set }
    var router: FileViewerRouterProtocol! { get set }
    
    var repository: Repository! { get set }
    var path: String! { get set }
    
    // MARK: - input
    func viewDidLoad()
    
    // MARK: - output
    func getFileLink() -> String 
}

protocol FileViewerInteractorProtocol {
    
    var presenter: FileViewerPresenterProtocol! { get set }
    
    func getFileContent(repo: Repository, path: String, callback : @escaping(_ htmlSource : String?)-> Void)
}

protocol FileViewerRouterProtocol {
    
}
