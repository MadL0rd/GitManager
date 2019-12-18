//
//  IssuePageViewController.swift
//  GitManager
//
//  Created by Антон Текутов on 13.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit
import MarkdownView
import SafariServices

class IssuePageViewController: UIViewController, IssuePageViewProtocol, UITextFieldDelegate {
    
    var presenter: IssuePagePresenterProtocol?
    
    private var width : CGFloat = 300
    private var spacing : CGFloat = 20
    private var loading: LoadingViewProtocol = LoadingView()
    private let scroll = UIScrollView()
    private let stack = UIStackView()
    private let commentTextField = UITextField()
    private var mdViewRenderCount = 0
    private var commentsShowingStarts = false
    private var textFieldBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        width = view.frame.width
        spacing = width/15
        setupView()
        presenter?.viewDidLoad()
    }
    
    func setupView() {
        view.backgroundColor = Colors.mainBackground
        
        setupTextInput()
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
        md.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        md.onTouchLink = { [weak self] request in
            guard let url = request.url else { return false }
            
            if url.scheme == "file" {
                return true
            } else if url.scheme == "https" {
                let safari = SFSafariViewController(url: url)
                self?.present(safari, animated: true, completion: nil)
                return false
            } else {
                return false
            }
        }
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
                substack.spacing = spacing
                substack.setBackground(color: currentColor, cornerRadius: spacing / 2)
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
            md.onTouchLink = { [weak self] request in
                guard let url = request.url else { return false }
                
                if url.scheme == "file" {
                    return true
                } else if url.scheme == "https" {
                    let safari = SFSafariViewController(url: url)
                    self?.present(safari, animated: true, completion: nil)
                    return false
                } else {
                    return false
                }
            }
        }
        commentsShowingStarts = true
    }
    
    func showAddedComment(comment: IssueComment){
        var substack = UIStackView()
        var currentColor = Colors.otherComment
        
        if comment.owner{
            currentColor = Colors.selfComment
        } else {
            currentColor = Colors.otherComment
        }
        
        substack = UIStackView()
        stack.addArrangedSubview(substack)
        substack.axis = .vertical
        substack.spacing = spacing
        substack.setBackground(color: currentColor, cornerRadius: spacing / 2)
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
        
        let md = MarkdownView()
        md.layer.backgroundColor = UIColor.clear.cgColor
        mdViewRenderCount += 1
        md.load(markdown: "<style>body {background-color: \(currentColor.htmlRGBColor);}</style><font color=\"\(Colors.darkText.htmlRGBColor)\"> \(comment.body)")
        md.layer.cornerRadius = 20
        md.isScrollEnabled = false
        substack.addArrangedSubview(md)
        md.onRendered = mdRendered(_:)
        md.onTouchLink = { [weak self] request in
            guard let url = request.url else { return false }
            
            if url.scheme == "file" {
                return true
            } else if url.scheme == "https" {
                let safari = SFSafariViewController(url: url)
                self?.present(safari, animated: true, completion: nil)
                return false
            } else {
                return false
            }
        }
        
        scroll.scrollToBottom(animated: true)
    }
    
    
    private func setupTextInput(){
        view.addSubview(commentTextField)
        Designer.defaultTextFieldStyle(commentTextField)
        textFieldBottomConstraint = commentTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        textFieldBottomConstraint?.isActive = true
        commentTextField.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        commentTextField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        commentTextField.heightAnchor.constraint(equalToConstant: spacing * 2).isActive = true
        commentTextField.placeholder = NSLocalizedString("Type new comment here", comment: "Issue page")
        commentTextField.delegate = self
        commentTextField.returnKeyType = .done
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                if let view = self.view {
                    self.textFieldBottomConstraint?.isActive = false
                    self.textFieldBottomConstraint = self.commentTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardSize.height - self.spacing/4)
                    self.textFieldBottomConstraint?.isActive = true
                    self.view.layoutIfNeeded()
                }
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            if let view = self.view {
                self.textFieldBottomConstraint?.isActive = false
                self.textFieldBottomConstraint = self.commentTextField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
                self.textFieldBottomConstraint?.isActive = true
                self.view.layoutIfNeeded()
            }
        })
        
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
        scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: commentTextField.topAnchor).isActive = true
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        if let comment = textField.text {
            presenter?.addComment(text: comment)
            textField.text = nil
        }
        return true
    }
}
