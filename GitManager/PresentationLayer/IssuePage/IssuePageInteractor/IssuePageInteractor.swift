//
//  IssuePageInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 13.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class IssuePageInteractor: IssuePageInteractorProtocol {
    
    var presenter: IssuePagePresenterProtocol?
    var apiService: GitHubApiServiceProtocol? {
        didSet {
            getComments()
        }
    }
    var issueBuff: Issue? {
        didSet {
            guard let issue = self.issueBuff else { return }
            presenter?.showIssue(issue)
            getComments()
        }
    }
    private var lastDownloadedPage = 1
    private var itemsPerPage = 15
    
    func getComments() {
        guard let issue = issueBuff, apiService != nil else { return }
        lastDownloadedPage = 1
        apiService?.getIssuesComments(issue: issue, itemsPerPage: itemsPerPage, pageNumber: lastDownloadedPage, callback: setComments(_:))
    }
    
    private func setComments(_ comments: [IssueComment]){
        presenter?.showComments(comments)
    }
}
