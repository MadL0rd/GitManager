//
//  ReposListView.swift
//  GitManager
//
//  Created by Антон Текутов on 16.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposListViewController: UIViewController, ReposListViewProtocol{
    var reposViewer: ReposTableViewer?
    var presenter: ReposListPresenterProtocol?
    var searchController: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoad()
    }
    
    internal func setupView(){
        setupNavigationTitle()
        setupTableView()
        setupSearchController()
    }
    
    internal func setupNavigationTitle(){
        navigationItem.title = NSLocalizedString("My repositories", comment: "Title on repositories screen")
    }
    
    internal func setupTableView() {
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
    
    internal func setupSearchController(){
        guard let owner = presenter as? ReposSearchControllerOwnerProtocol else { return }
        searchController = ReposSearchController(owner: owner)
        searchController?.searchBar.placeholder = NSLocalizedString("Filter repositories", comment: "search controller")
        navigationItem.searchController = searchController
    }
    
    func showReposList() {
        reposViewer?.showReposList()
    }
    
    func reloadCellWithIndex(index: Int) {
        reposViewer?.refreshCell(index: index)
    }
    
    func setFiltersText(filters: [String]){
        searchController?.searchBar.scopeButtonTitles = filters
    }
}


