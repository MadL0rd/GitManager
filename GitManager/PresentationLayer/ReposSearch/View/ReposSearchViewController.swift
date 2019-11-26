//
//  ReposSearchViewController.swift
//  GitManager
//
//  Created by Антон Текутов on 14.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposSearchViewController: ReposListViewController, ReposSearchViewProtocol{
    
    var presenterStarred: ReposSearchPresenterProtocol?
    
    override func setupNavigationTitle() {
        navigationItem.title = NSLocalizedString("Search", comment: "Title on repositories screen")
    }
    
    override func setupAddictionalContentMode() {
        reposViewer?.setAddictionalContentMode(mode: .Search)
    }
    
    override func setupInheritor(){

    }
    
    override func setFiltersText(filters: [String]){
        filtrationView.filters.deleteGroup(groupTitle: "Languages", type: .tag)
        filtrationView.filters.addParameter(name: NSLocalizedString("Language", comment: "addictional parametr 2 query")
            , type: .string, groupTitle: NSLocalizedString("Additional query parameters", comment: "filter group title"))
        for filter in filters{
            filtrationView.filters.addParameter(name: filter, type: .tag, groupTitle: NSLocalizedString("Languages", comment: "filters title"))
        }
        filtrationView.drawUI()
    }
}
