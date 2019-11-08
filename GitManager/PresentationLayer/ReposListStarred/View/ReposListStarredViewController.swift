//
//  ReposListStarredViewController.swift
//  GitManager
//
//  Created by Антон Текутов on 08.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposListStarredViewController: UIViewController, ReposListStarredViewProtocol{
    
    var reposViewer: ReposTableViewer?
    var presenter: ReposListStarredPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Starred repositories", comment: "Title on repositories screen")
        let editString = NSLocalizedString("Edit Profile", comment: "Button on repositories screen")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: editString, style: .plain, target: self, action: #selector(editProfile))
        setupTableView()

        presenter?.viewDidLoad()
    }
    
    func setupTableView() {
        guard let owner = presenter as? ReposTableViewerOwnerProtocol else { return }
        reposViewer = ReposTableViewer(owner: owner)
        guard let reposView = reposViewer else { return }
        view.addSubview(reposView)
        reposView.translatesAutoresizingMaskIntoConstraints = false
        reposView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        reposView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        reposView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        reposView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        reposView.backgroundColor = Colors.mainBackground
    }
    
    @objc func editProfile(){
        presenter?.showProfileEditor()
    }
    
    func showReposList() {
        reposViewer?.showReposList()
    }
    
    func repoladCellWithIndex(index: Int) {
        reposViewer?.refreshCell(index: index)
    }
}


