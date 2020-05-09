//
//  FileSystemProtocols.swift
//  GitManager
//
//  Created by Антон Текутов on 05.04.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

protocol FileSystemViewProtocol {
    
    var presenter: FileSystemPresenterProtocol! { get set }
    
    func showSelectedBranch(_ branch: String)
    func setTitle(_ title: String)
    func showCatalog(_ catalog: [Directory], havePreviousDir: Bool)
    func showPath(_ path: String)
}

protocol FileSystemPresenterProtocol {
    
    var view: FileSystemViewProtocol? { get set }
    var interactor: FileSystemInteractorProtocol! { get set }
    var router: FileSystemRouterProtocol! { get set }
    
    func viewDidLoad()
    func selectBranch(_ branch: String)
    func getBranches() -> [String]
    func cellDidTapped(_ index: Int)
    func getFolderLink() -> String
}

protocol FileSystemInteractorProtocol {
    
    var presenter: FileSystemPresenterProtocol! { get set }
    
    func getBranches(repo: Repository, callback : @escaping(_ branches : [String])-> Void)
    func getBranchRootDirectory(repo: Repository, branch: String, callback: @escaping (Directory) -> Void)
    func getDirectoryContent(dir: Directory, callback : @escaping(_ directories : [Directory])-> Void)
}

protocol FileSystemRouterProtocol {
    
    func showFile(repo: Repository, path: String)
}
