//
//  ReposPageViewController.swift
//  GitManager
//
//  Created by Антон Текутов on 29.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ReposPageView: UIViewController, ReposPageViewProtocol{
    var presenter: ReposPagePresenterProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.mainBackground
        setupView()
        presenter?.viewDidLoad()
    }
    
    func setupView() {
        
    }
    
    func showRepository(_ repository: Repository?) {
        navigationItem.title = repository?.name
    }
}
