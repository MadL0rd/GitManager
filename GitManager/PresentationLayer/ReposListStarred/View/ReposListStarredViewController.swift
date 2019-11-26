//
//  ReposListStarredViewController.swift
//  GitManager
//
//  Created by Антон Текутов on 08.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposListStarredViewController: ReposListViewController, ReposListStarredViewProtocol{
    
    var presenterStarred: ReposListStarredPresenterProtocol?
    
    override func setupNavigationTitle() {
        navigationItem.title = NSLocalizedString("Starred repositories", comment: "Title on repositories screen")
    }
    
    override func setupAddictionalContentMode() {
        reposViewer?.setAddictionalContentMode(mode: .Search)
    }
}


