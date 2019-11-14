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
}
