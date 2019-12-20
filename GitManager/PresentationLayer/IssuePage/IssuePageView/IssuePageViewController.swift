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
    
    private static var keyboardHeight: CGFloat?
    private var width : CGFloat = 300
    private var spacing : CGFloat = 20
    private var loading: LoadingViewProtocol = LoadingView()
    private let scroll = UIScrollView()
    private let stack = UIStackView()
    private let stateLabel = UILabel()
    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    private let newCommentPlaceholderView = UIView()
    private let commentTextField = UITextField()
    private var mdViewRenderCount = 0
    private var commentsShowingStarts = false
    private var needToScrollToLastComment = false
    private var newCommentPlaceholderBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        width = view.frame.width
        spacing = width/15
        setupView()
        presenter?.viewDidLoad()
    }
    
     private func setupView() {
        view.backgroundColor = Colors.mainBackground
        
        setupTextInput()
        setupScrollView()
        setupStackView()
        setupLoading()
    }
    
    private func setupIssueInfoContainers() {
        Designer.mainTitleLabel(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
        stack.addArrangedSubview(titleLabel)
        titleLabel.leftAnchor.constraint(equalTo: stack.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: stack.rightAnchor).isActive = true
        
        Designer.subTitleLabel(infoLabel)
        infoLabel.numberOfLines = 0
        infoLabel.lineBreakMode = .byWordWrapping
        infoLabel.textAlignment = .center
        stack.addArrangedSubview(infoLabel)
        infoLabel.leftAnchor.constraint(equalTo: stack.leftAnchor).isActive = true
        infoLabel.rightAnchor.constraint(equalTo: stack.rightAnchor).isActive = true
        
        Designer.bigTitleLabel(stateLabel)
        stateLabel.textAlignment = .center
        stateLabel.layer.cornerRadius = spacing / 2
        stateLabel.layer.borderWidth = spacing / 10
        stack.addArrangedSubview(stateLabel)
        stateLabel.leftAnchor.constraint(equalTo: stack.leftAnchor).isActive = true
        stateLabel.rightAnchor.constraint(equalTo: stack.rightAnchor).isActive = true
    }
    
    func showIssue(_ issue: Issue) {
        setupIssueInfoContainers()
        
        let issueString = NSLocalizedString("Issue", comment: "navigation title")
        navigationItem.title = "\(issueString) #\(issue.number ?? 0)"
        
        titleLabel.text = issue.title
        if issue.open {
            stateLabel.layer.borderColor = Colors.addictionalInfoPrivate.cgColor
            stateLabel.textColor = Colors.addictionalInfoPrivate
            stateLabel.text = "!"
        } else {
            stateLabel.layer.borderColor = Colors.addictionalInfoPublic.cgColor
            stateLabel.textColor = Colors.addictionalInfoPublic
            stateLabel.text = "✓"
        }
        
        if let number = issue.number, let login = issue.user?.login{
            
            let opened = NSLocalizedString("opened on", comment: "issues info")
            let closed = NSLocalizedString("was closed on", comment: "issues info")
            let by = NSLocalizedString("by", comment: "issues info")
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy"
            
            if issue.open {
                infoLabel.text = "#\(number) \(opened) \(formatter.string(from: issue.createdAt)) \(by) \(login)"
            } else {
                infoLabel.text = "#\(number) \(by) \(login) \(closed) \(formatter.string(from: issue.closedAt))"
            }
        }
        
        let md = MarkdownView()
        stack.addArrangedSubview(md)
        md.leftAnchor.constraint(equalTo: stack.leftAnchor).isActive = true
        md.rightAnchor.constraint(equalTo: stack.rightAnchor).isActive = true
        mdViewRenderCount += 1
        md.load(markdown: issue.body)
        md.isScrollEnabled = false
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
        needToScrollToLastComment = true
        
        let commentStack = UIStackView()
        stack.addArrangedSubview(commentStack)
        commentStack.axis = .horizontal
        commentStack.spacing = spacing / 4
        
        let substack = UIStackView()
        commentStack.addArrangedSubview(substack)
        var currentColor = Colors.otherComment
        
        if comment.owner{
            currentColor = Colors.selfComment
        } else {
            currentColor = Colors.otherComment
        }
        
        substack.axis = .vertical
        substack.spacing = spacing
        substack.setBackground(color: currentColor, cornerRadius: spacing / 2)
        substack.isLayoutMarginsRelativeArrangement = true
        substack.layoutMargins = UIEdgeInsets(top: spacing/2, left: spacing/2, bottom: spacing/2, right: spacing/2)
        
        let profileImageView = UIImageView()
        commentStack.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.heightAnchor.constraint(equalToConstant: width / 8).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: width / 8).isActive = true
        profileImageView.backgroundColor = Colors.backgroundDark
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = width / 16
        profileImageView.layer.masksToBounds = true
        profileImageView.downloadFromUrl(url: comment.user?.avatarUrl ?? "")
        
        if comment.owner {
            commentStack.addArrangedSubview(substack)
            commentStack.addArrangedSubview(profileImageView)
        } else {
            commentStack.addArrangedSubview(profileImageView)
            commentStack.addArrangedSubview(substack)
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
    
    
    private func setupTextInput(){
        view.addSubview(newCommentPlaceholderView)
        newCommentPlaceholderView.translatesAutoresizingMaskIntoConstraints = false
        newCommentPlaceholderView.backgroundColor = Colors.mainBackground
        newCommentPlaceholderBottomConstraint = newCommentPlaceholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        newCommentPlaceholderBottomConstraint?.isActive = true
        newCommentPlaceholderView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        newCommentPlaceholderView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        newCommentPlaceholderView.heightAnchor.constraint(equalToConstant: spacing * 2).isActive = true
        
        let placeholderStack = UIStackView()
        placeholderStack.translatesAutoresizingMaskIntoConstraints = false
        newCommentPlaceholderView.addSubview(placeholderStack)
        placeholderStack.setMargin(spacing / 8)
        placeholderStack.spacing = spacing / 8
        placeholderStack.axis = .horizontal
        
        placeholderStack.addArrangedSubview(commentTextField)
        Designer.defaultTextFieldStyle(commentTextField)
        commentTextField.placeholder = NSLocalizedString("Type new comment here", comment: "Issue page")
        commentTextField.delegate = self
        commentTextField.returnKeyType = .done
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
        let button = UIButton()
        Designer.smallButton(button)
        button.setTitle("➤", for: .normal)
        button.widthAnchor.constraint(equalToConstant: spacing * 1.5).isActive = true
        button.addTarget(self, action: #selector(sendComment), for: .touchDown)
        placeholderStack.addArrangedSubview(button)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.07, animations: { () -> Void in
                if let view = self.view {
                    if IssuePageViewController.keyboardHeight == nil {
                        IssuePageViewController.keyboardHeight = keyboardSize.height
                    }
                    guard let height = IssuePageViewController.keyboardHeight else { return }
                    self.newCommentPlaceholderBottomConstraint?.isActive = false
                    print(keyboardSize)
                    self.newCommentPlaceholderBottomConstraint = self.newCommentPlaceholderView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -height)
                    self.newCommentPlaceholderBottomConstraint?.isActive = true
                    self.view.layoutIfNeeded()
                }
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.07, animations: { () -> Void in
            if let view = self.view {
                self.newCommentPlaceholderBottomConstraint?.isActive = false
                self.newCommentPlaceholderBottomConstraint = self.newCommentPlaceholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
                self.newCommentPlaceholderBottomConstraint?.isActive = true
                self.view.layoutIfNeeded()
            }
        })
        
    }
    
    private func mdRendered(_ value: CGFloat){
        mdViewRenderCount -= 1
        if mdViewRenderCount == 0 && commentsShowingStarts {
            loading.hide()
        }
        if needToScrollToLastComment {
            scroll.scrollToBottom(animated: true)
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
        scroll.bottomAnchor.constraint(equalTo: newCommentPlaceholderView.topAnchor).isActive = true
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
    
    @objc private func sendComment(){
        commentTextField.resignFirstResponder()
        if let comment = commentTextField.text {
            presenter?.addComment(text: comment)
            commentTextField.text = nil
        }
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
