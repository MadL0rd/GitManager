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
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = NSLocalizedString("Starred repositories", comment: "Title on repositories screen")
        setupTableView()

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("Filter repositories", comment: "search controller")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil, queue: .main) { (notification) in
                                        self.handleKeyboard(notification: notification) }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                       object: nil, queue: .main) { (notification) in
                                        self.handleKeyboard(notification: notification) }
        
        presenter?.viewDidLoad()
    }
    
    func setFiltersText(filters: [String]){
        searchController.searchBar.scopeButtonTitles = filters
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
    
    func handleKeyboard(notification: Notification) {
      // 1
      guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
        //searchFooterBottomConstraint.constant = 0
        view.layoutIfNeeded()
        return
      }
      
      guard
        let info = notification.userInfo,
        let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
          return
      }
      
      // 2
      let keyboardHeight = keyboardFrame.cgRectValue.size.height
      UIView.animate(withDuration: 0.1, animations: { () -> Void in
        //self.searchFooterBottomConstraint.constant = keyboardHeight
        self.view.layoutIfNeeded()
      })
    }
}

extension ReposListStarredViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    presenter?.applyFilters(text: searchBar.text?.lowercased(), language: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
  }
}

extension ReposListStarredViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    presenter?.applyFilters(text: searchBar.text?.lowercased(), language: searchBar.scopeButtonTitles![selectedScope])
  }
}


