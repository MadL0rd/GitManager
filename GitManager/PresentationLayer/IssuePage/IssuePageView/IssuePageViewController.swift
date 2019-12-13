//
//  IssuePageViewController.swift
//  GitManager
//
//  Created by Антон Текутов on 13.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class IssuePageViewController: UIViewController, IssuePageViewProtocol {
    
    var presenter: IssuePagePresenterProtocol?
    
    private var width : CGFloat = 300
    private var spacing : CGFloat = 20
    private var loading: LoadingViewProtocol = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = view.frame.width
        spacing = width/15
        setupView()
        presenter?.viewDidLoad()
    }
    
    func setupView() {
        view.backgroundColor = Colors.mainBackground
        
        setupNavigation()
        setupLoading()
    }
    
    func showIssue(_ issue: Issue) {
        
    }
    
    func showComments(_ comments: [IssueComment]) {

    }
    
    
    private func setupLoading(){
        view.addSubview(loading)
        loading.setMargin(0)
        loading.show(animation: false)
    }
    
    internal func setupNavigation(){
        navigationItem.title = NSLocalizedString("Issue", comment: "navigation title")
    }
}
