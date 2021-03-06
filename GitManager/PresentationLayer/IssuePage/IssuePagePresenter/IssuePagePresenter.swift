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
        if interactor?.getMoreContentDawnloadPossibility() == true {
            view?.showNextPageButton()
        }
        view?.showComments(comments)
    }
    
    func showIssue(_ issue: Issue) {
        view?.showIssue(issue)
    }
    
    func addComment(text: String) {
        interactor?.addComment(text: text)
    }
    
    func showAddedComment(comment: IssueComment){
        view?.showAddedComment(comment: comment)
    }

    func loadNextPage() {
        view?.hideNextPageButton()
        interactor?.getComments()
    }
}
