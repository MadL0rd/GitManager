//
//  FileSystemPresenter.swift
//  GitManager
//
//  Created by Антон Текутов on 05.04.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

class FileSystemPresenter: FileSystemPresenterProtocol {

    var view: FileSystemViewProtocol?
    var interactor: FileSystemInteractorProtocol!
    var router: FileSystemRouterProtocol!
    
    var repository: Repository!
    var currentDirectory: Directory?
    var currentCatalog = [Directory]()
    var path = [Directory]()
    
    private var branches = [String]()
    private var selectedBranch = ""
    
    // MARK: - input
    
    func viewDidLoad() {
        interactor.getBranches(repo: repository, callback: setBranches(_:))
        view?.setTitle(repository.name)
    }
    
    func selectBranch(_ branch: String) {
        selectedBranch = branch
        view?.showSelectedBranch(selectedBranch)
        interactor.getBranchRootDirectory(repo: repository, branch: selectedBranch, callback: { [ weak self ] dir in
            guard let self = self 
                else { return }
            self.currentDirectory = dir
            self.path.removeAll()
            self.interactor.getDirectoryContent(dir: dir, callback: self.setCatalog(_:))
        })
    }
    
    func cellDidTapped(_ index: Int) {
        if index >= 0 && index < currentCatalog.count {
            let dir = currentCatalog[index]
            if dir.type == .file {
                router.showFile(dir)
            } else {
                if let directory = currentDirectory {
                    if path.last == dir {
                        path.removeLast()
                    } else {
                        path.append(directory)
                    }
                }
                currentDirectory = dir
                interactor.getDirectoryContent(dir: dir, callback: setCatalog(_:))
            }
        } else {
            print("Catalog item index error!")
        }
    }
    
    // MARK: - output
    
    func getBranches() -> [String] {
        return branches
    }
    
    // MARK: - Private methods
    
    private func setBranches(_ branches : [String]) {
        self.branches = branches
        if branches.contains("master") {
            selectedBranch = "master"
        } else {
            selectedBranch = branches[0]
        }
        selectBranch(selectedBranch)
    }
    
    private func setCatalog(_ catalog: [Directory]) {
        currentCatalog = catalog
        if let lastDir = path.last {
            currentCatalog.insert(lastDir, at: 0)
        }
        view?.showCatalog(currentCatalog, havePreviousDir: path.count != 0)
        refreshPathView()
    }
    
    private func refreshPathView() {
        var pathText = ""
        for node in path {
            pathText += "/" + node.name
        }
        if let currentNode = currentDirectory {
            pathText += "/" + currentNode.name 
        }
        view?.showPath(pathText)
    }
}
