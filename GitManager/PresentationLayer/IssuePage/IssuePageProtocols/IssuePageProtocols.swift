//
//  IssuePageProtocols.swift
//  GitManager
//
//  Created by Антон Текутов on 13.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

protocol IssuePageViewProtocol {
    var presenter:  IssuePagePresenterProtocol?     { get set }
    
    func showIssue(_ issue: Issue)
    func showComments(_ comments: [IssueComment])
    func showAddedComment(comment: IssueComment)
    func hideNextPageButton()
    func showNextPageButton()
}

protocol IssuePagePresenterProtocol {
    var view:       IssuePageViewProtocol?          { get set }
    var interactor: IssuePageInteractorProtocol?    { get set }
    var router:     IssuePageRouterProtocol?        { get set }
    
    func viewDidLoad()
    func showComments(_ comments: [IssueComment])
    func showIssue(_ issue: Issue)
    func addComment(text: String)
    func showAddedComment(comment: IssueComment)
    func loadNextPage()
}

protocol IssuePageInteractorProtocol {
    var presenter:      IssuePagePresenterProtocol?         { get set }
    var apiService:     GitHubApiServiceProtocol?           { get set }
    var issueBuff:      Issue?                              { get set }
    
    func getComments()
    func addComment(text: String)
    func getMoreContentDawnloadPossibility() -> Bool
}

protocol IssuePageRouterProtocol {
    var presenter:  IssuePagePresenterProtocol?     { get set }
}
