//
//  IssuePagePresenter.swift
//  GitManager
//
//  Created by Антон Текутов on 13.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class IssuePagePresenter: IssuePagePresenterProtocol {
    
    var view: IssuePageViewProtocol?
    var interactor: IssuePageInteractorProtocol?
    var router: IssuePageRouterProtocol?
    
    func viewDidLoad() {
        
    }
    
    func showComments(_ comments: [IssueComment]) {
        view?.showComments(comments)
    }
    
    func showIssue(_ issue: Issue) {
        view?.showIssue(issue)
    }
    
    
}
