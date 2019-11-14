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
    
    func setFiltersText(filters: [String]) {
        searchBar.scopeButtonTitles = filters
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchResultsUpdater = self
        obscuresBackgroundDuringPresentation = false
        searchBar.delegate = self
    }
}

extension ReposSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        owner?.applyFilters(text: searchBar.text?.lowercased(), language: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
    }
}

extension ReposSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        owner?.applyFilters(text: searchBar.text?.lowercased(), language: searchBar.scopeButtonTitles![selectedScope])
    }
}
