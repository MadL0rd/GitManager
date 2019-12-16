//
//  IssuePageViewController.swift
//  GitManager
//
//  Created by Антон Текутов on 13.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit
import MarkdownView

class IssuePageViewController: UIViewController, IssuePageViewProtocol {
    
    var presenter: IssuePagePresenterProtocol?
    
    private var width : CGFloat = 300
    private var spacing : CGFloat = 20
    private var loading: LoadingViewProtocol = LoadingView()
    private let scroll = UIScrollView()
    private let stack = UIStackView()
    private var mdViewRenderCount = 0
    private var commentsShowingStarts = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = view.frame.width
        spacing = width/15
        setupView()
        presenter?.viewDidLoad()
    }
    
    func setupView() {
        view.backgroundColor = Colors.mainBackground
        
        setupScrollView()
        setupStackView()
        setupLoading()
    }
    
    func showIssue(_ issue: Issue) {
        let issueString = NSLocalizedString("Issue", comment: "navigation title")
        navigationItem.title = "\(issueString) #\(issue.number ?? 0)"
        let md = MarkdownView()
        mdViewRenderCount += 1
        md.load(markdown: issue.body)
        md.isScrollEnabled = false
        md.onRendered = mdRendered(_:)
        stack.addArrangedSubview(md)
    }
    
    func showComments(_ comments: [IssueComment]) {
        var substack = UIStackView()
        var currentCommentator: Int64? = nil
        var currentColor = Colors.otherComment
        for comment in comments {
            if currentCommentator != comment.user?.id {
                currentCommentator = comment.user?.id
                
                if comment.owner{
                    currentColor = Colors.selfComment
                } else {
                    currentColor = Colors.otherComment
                }
                
                substack = UIStackView()
                stack.addArrangedSubview(substack)
                substack.axis = .vertical
                substack.spacing = 20
                substack.setBackground(color: currentColor, cornerRadius: spacing)
                substack.isLayoutMarginsRelativeArrangement = true
                substack.layoutMargins = UIEdgeInsets(top: spacing/2, left: spacing/2, bottom: spacing/2, right: spacing/2)
                substack.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.85).isActive = true
                
                let profileImageView = UIImageView()
                stack.addSubview(profileImageView)
                profileImageView.translatesAutoresizingMaskIntoConstraints = false
                profileImageView.heightAnchor.constraint(equalToConstant: width / 8).isActive = true
                profileImageView.widthAnchor.constraint(equalToConstant: width / 8).isActive = true
                profileImageView.topAnchor.constraint(equalTo: substack.topAnchor).isActive = true
                profileImageView.backgroundColor = Colors.backgroundDark
                profileImageView.contentMode = .scaleAspectFill
                profileImageView.layer.cornerRadius = width / 16
                profileImageView.layer.masksToBounds = true
                profileImageView.downloadFromUrl(url: comment.user?.avatarUrl ?? "")
                
                if comment.owner {
                    substack.leftAnchor.constraint(equalTo: stack.leftAnchor).isActive = true
                    profileImageView.rightAnchor.constraint(equalTo: stack.rightAnchor).isActive = true
                } else {
                    substack.rightAnchor.constraint(equalTo: stack.rightAnchor).isActive = true
                    profileImageView.leftAnchor.constraint(equalTo: stack.leftAnchor).isActive = true
                }
            }
            let md = MarkdownView()
            md.layer.backgroundColor = UIColor.clear.cgColor
            mdViewRenderCount += 1
            md.load(markdown: "<style>body {background-color: \(currentColor.htmlRGBColor);}</style><font color=\"\(Colors.darkText.htmlRGBColor)\"> \(comment.body)")
            md.layer.cornerRadius = 20
            md.isScrollEnabled = false
            substack.addArrangedSubview(md)
            md.onRendered = mdRendered(_:)
        }
        commentsShowingStarts = true
    }
    
    private func mdRendered(_ value: CGFloat){
        mdViewRenderCount -= 1
        if mdViewRenderCount == 0 && commentsShowingStarts {
            loading.hide()
        }
    }
    
    
    private func setupLoading(){
        view.addSubview(loading)
        loading.setMargin(0)
        loading.show(animation: false)
    }
    
    private func setupScrollView(){
        view.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.setMargin(0)
        scroll.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    private func setupStackView(){
        scroll.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setMargin(baseView: scroll, left: 0, top: 20, right: 0, bottom: 0)
        stack.widthAnchor.constraint(equalTo: scroll.widthAnchor, multiplier: 0.9).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.axis = .vertical
        stack.spacing = 20
    }
}
