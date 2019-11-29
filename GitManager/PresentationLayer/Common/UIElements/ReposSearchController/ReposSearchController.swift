//
//  ReposSearchController.swift
//  GitManager
//
//  Created by Антон Текутов on 12.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposSearchController: UISearchController, ReposSearchControllerProtocol {
    
    private var owner : ReposSearchControllerOwnerProtocol?
    
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)
    }
    
    required convenience init(owner: ReposSearchControllerOwnerProtocol) {
        self.init(searchResultsController: nil)
        self.owner = owner
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setScopeBottonsText(buttonsText : [String]) {
        searchBar.scopeButtonTitles = buttonsText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultsUpdater = self
        obscuresBackgroundDuringPresentation = false
        searchBar.delegate = self
        
        searchBar.delegate = self
        searchBar.showsBookmarkButton = true
        searchBar.setImage(UIImage(named: "filter"), for: .bookmark, state: .normal)
    }
}

extension ReposSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        owner?.searchTextChanged(text: searchBar.text?.lowercased() ?? "")
    }
}

extension ReposSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        owner?.filterButtonPressed()
    }
    
}
