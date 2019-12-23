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
    private var canDownloadMoreContent = false
    private var allCommentsWasDownloaded = false
    
    func getComments() {
        guard let issue = issueBuff, apiService != nil else { return }
        canDownloadMoreContent = false
        apiService?.getIssuesComments(issue: issue, itemsPerPage: itemsPerPage, pageNumber: lastDownloadedPage, callback: setComments(_:))
        lastDownloadedPage += 1
    }
    
    func addComment(text: String) {
        guard let issue = issueBuff else { return }
        apiService?.addCommentToIssue(issue: issue, comment: text, callback: pushAddedComment(comment:))
    }
    
    func pushAddedComment(comment: IssueComment) {
        if allCommentsWasDownloaded {
            presenter?.showAddedComment(comment: comment)
        }
    }
    
    private func setComments(_ comments: [IssueComment]){
        if comments.count < itemsPerPage{
            canDownloadMoreContent = false
            allCommentsWasDownloaded = true
        }else{
            canDownloadMoreContent = true
        }
        presenter?.showComments(comments)
    }
    
    func getMoreContentDawnloadPossibility() -> Bool {
        return canDownloadMoreContent
    }
}
