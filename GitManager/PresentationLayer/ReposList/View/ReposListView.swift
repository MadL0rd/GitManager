//
//  ReposListView.swift
//  GitManager
//
//  Created by Антон Текутов on 16.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposListView: UIViewController, ReposListViewProtocol, UITableViewDataSource, UITableViewDelegate {
    
    var tableViewRepositories = UITableView()
    var presenter: ReposListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("My repositories", comment: "Title on repositories screen")
        let editString = NSLocalizedString("Edit Profile", comment: "Button on repositories screen")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: editString, style: .plain, target: self, action: #selector(editProfile))
        setupTableView()

        presenter?.viewDidLoad()
    }
    
    func setupTableView() {
        view.addSubview(tableViewRepositories)
        tableViewRepositories.translatesAutoresizingMaskIntoConstraints = false
        tableViewRepositories.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableViewRepositories.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableViewRepositories.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableViewRepositories.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableViewRepositories.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableViewRepositories.dataSource = self
        tableViewRepositories.delegate = self
        tableViewRepositories.register(RepositoryTabelViewCell.self, forCellReuseIdentifier: "repositoryCell")
        //tableViewRepositories.rowHeight = 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getItemsCount() == nil ? 0 : presenter?.getItemsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath) as! RepositoryTabelViewCell
        cell.starButton.addTarget(self, action: #selector(starRepository), for: .touchUpInside)
        cell.showRepository(repos: presenter?.getItemWithIndex(index: indexPath.row))
        return cell
    }
    
    @objc func starRepository(sender: UIButton!){
        guard let cell = sender.superview?.superview as? RepositoryTabelViewCell else {return}
        guard let index = tableViewRepositories.indexPath(for: cell)?.row else {return}
        presenter?.starRepository(index: index)
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.showReposPageByItemIndex(index: indexPath.row)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showReposList() {
        tableViewRepositories.reloadData()
    }
    
    @objc func editProfile(){
        presenter?.showProfileEditor()
    }
}


