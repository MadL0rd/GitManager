//
//  ReposTableViewer.swift
//  GitManager
//
//  Created by Антон Текутов on 08.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposTableViewer: UIView, UITableViewDataSource, UITableViewDelegate, ReposTableViewerProtocol {
   
    var tableViewRepositories = UITableView()
    private var owner: ReposTableViewerOwnerProtocol?
    
    override init (frame : CGRect) {
        super.init(frame : frame)
    }
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    required convenience init(owner: ReposTableViewerOwnerProtocol) {
        self.init()
        self.owner = owner
        setupTableView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableView() {
        addSubview(tableViewRepositories)
        tableViewRepositories.translatesAutoresizingMaskIntoConstraints = false
        tableViewRepositories.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableViewRepositories.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableViewRepositories.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableViewRepositories.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableViewRepositories.dataSource = self
        tableViewRepositories.delegate = self
        tableViewRepositories.register(RepositoryTabelViewCell.self, forCellReuseIdentifier: "repositoryCell")
        tableViewRepositories.backgroundColor = Colors.mainBackground
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return owner?.getItemsCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath) as! RepositoryTabelViewCell
        cell.starButton.addTarget(self, action: #selector(starRepository), for: .touchUpInside)
        let repos = owner?.getItemWithIndex(index: indexPath.row)
        cell.showRepository(repos: repos)
        return cell
    }
    
    @objc func starRepository(sender: UIButton!){
        guard let cell = sender.superview?.superview as? RepositoryTabelViewCell else {return}
        guard let index = tableViewRepositories.indexPath(for: cell)?.row else {return}
        owner?.starRepository(index: index)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        owner?.showRepositoryPage(index: indexPath.row)
    }
    
    func refreshCell(index: Int) {
        tableViewRepositories.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func showReposList() {
        tableViewRepositories.reloadData()
    }
}


