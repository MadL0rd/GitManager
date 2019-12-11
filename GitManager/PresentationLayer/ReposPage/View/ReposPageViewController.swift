//
//  ReposPageViewController.swift
//  GitManager
//
//  Created by Антон Текутов on 29.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit
import WebKit

class ReposPageViewController: UIViewController, ReposPageViewProtocol, WKNavigationDelegate{
    var presenter: ReposPagePresenterProtocol?
    private var repositoryBuff : Repository?
    private let scroll = UIScrollView()
    private let stack = UIStackView()
    private var width : CGFloat = 300
    private var spacing : CGFloat = 20
    
    private let profileImageView = UIImageView()
    private let ownerNameLabel = UILabel()
    private let ownerLoginLabel = UILabel()
    private let ownerCompanyLabel = UILabel()
    private let reposNameLabel = UILabel()
    private let starredButton = TwoStateButton()
    private let addictionalInfo = AddictionalInformationStack()
    private let descriptionText = UILabel()
    private var webView = WKWebView()
    private var webViewFirstLoadingComplete = false
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
        
        setupScrollView()
        setupStackView()
        setupOwnerInfo()
        setupReposInfo()
        setupLoading()
    }
    
    func showRepository(_ repository: Repository) {
        repositoryBuff = repository
        
        navigationItem.title = repository.name
        let image = UIImage(named: "sharing")
        let button = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(shareRepository))
        navigationItem.rightBarButtonItem = button
        
        profileImageView.downloadFromUrl(url: repository.owner?.avatarUrl ?? "")
        ownerNameLabel.text = repository.owner?.name ?? ""
        ownerLoginLabel.text = repository.owner?.login ?? ""
        ownerCompanyLabel.text = repository.owner?.company == "" ? NSLocalizedString("*not stated*", comment: "Repos page") : repository.owner?.company
        
        reposNameLabel.text = repository.name
        if repository.starred{
            starredButton.setActive()
        }else{
            starredButton.setBlocked()
        }
        addictionalInfo.setContent(repos: repository, mode: .Full)
        descriptionText.text = repository.description == "" ? NSLocalizedString("*not stated*", comment: "Repos page") : repository.description
    }
    
    func changeStarredStatus() {
        starredButton.toggle()
    }
    
    @objc private func shareRepository(){
        let textToShare = [ repositoryBuff?.url ]
        let activityViewController = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func setupScrollView(){
        view.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.setMargin(baseView: view.safeAreaLayoutGuide, 0)
    }
    private func setupStackView(){
        scroll.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setMargin(left: 0, top: width/20, right: 0, bottom: 0)
        stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.axis = .vertical
        stack.spacing = spacing
    }
    
    private func setupOwnerInfo(){
        let ownerStack = UIStackView()
        ownerStack.axis = .horizontal
        ownerStack.distribution = .fill
        ownerStack.spacing = spacing
        
        profileImageView.heightAnchor.constraint(equalToConstant: width/3).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: width/3).isActive = true
        profileImageView.backgroundColor = Colors.backgroundDark
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = width/6
        profileImageView.layer.masksToBounds = true
        ownerStack.addArrangedSubview(profileImageView)
        
        let ownerSubstack = UIStackView()
        ownerSubstack.axis = .vertical
        ownerSubstack.distribution = .equalCentering
        var label = UILabel()
        label.text = NSLocalizedString("Owner:", comment: "Repos page")
        Designer.subTitleLabel(label)
        ownerSubstack.addArrangedSubview(label)
        Designer.mainTitleLabel(ownerNameLabel)
        ownerSubstack.addArrangedSubview(ownerNameLabel)
        
        label = UILabel()
        label.text = NSLocalizedString("with login:", comment: "Repos page")
        Designer.subTitleLabel(label)
        ownerSubstack.addArrangedSubview(label)
        Designer.mainTitleLabel(ownerLoginLabel)
        ownerSubstack.addArrangedSubview(ownerLoginLabel)
        
        label = UILabel()
        label.text = NSLocalizedString("from company:", comment: "Repos page (from *company name*)")
        Designer.subTitleLabel(label)
        ownerSubstack.addArrangedSubview(label)
        Designer.mainTitleLabel(ownerNameLabel)
        ownerSubstack.addArrangedSubview(ownerCompanyLabel)
        
        ownerStack.addArrangedSubview(ownerSubstack)
        stack.addArrangedSubview(ownerStack)
    }
    
    private func setupReposInfo(){
        let titleStack = UIStackView()
        titleStack.axis = .horizontal
        titleStack.spacing = spacing
        
        Designer.bigTitleLabel(reposNameLabel)
        titleStack.addArrangedSubview(reposNameLabel)
        starredButton.setInteractionAbilityChanging(changeByStates: false)
        starredButton.setChangingText(active: "★", blocked: "✩")
        starredButton.addTarget(self, action: #selector(starRepository), for: .touchUpInside)
        titleStack.addArrangedSubview(starredButton)
        
        stack.addArrangedSubview(titleStack)
        
        addictionalInfo.heightAnchor.constraint(equalToConstant: width/10).isActive = true
        addictionalInfo.distribution = .fillProportionally
        stack.addArrangedSubview(addictionalInfo)
        
        let buttonsStack = UIStackView()
        var button = UIButton()
        button.setTitle(NSLocalizedString("Issues", comment: "Repos page button"), for: .normal)
        Designer.smallButton(button)
        button.addTarget(self, action: #selector(showIssues), for: .touchUpInside)
        buttonsStack.addArrangedSubview(button)
        button = UIButton()
        button.setTitle(NSLocalizedString("Branches", comment: "Repos page button"), for: .normal)
        Designer.smallButton(button)
        button.addTarget(self, action: #selector(showBranches), for: .touchUpInside)
        buttonsStack.addArrangedSubview(button)
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = spacing
        buttonsStack.distribution = .fillEqually
        stack.addArrangedSubview(buttonsStack)
        
        var label = UILabel()
        label.text = NSLocalizedString("Description:", comment: "Repos page")
        Designer.mainTitleLabel(label)
        stack.addArrangedSubview(label)
        
        Designer.mainTitleLabel(descriptionText)
        descriptionText.lineBreakMode = .byWordWrapping
        descriptionText.numberOfLines = 0
        descriptionText.widthAnchor.constraint(equalToConstant: width*0.8).isActive = true
        stack.addArrangedSubview(descriptionText)
        
        label = UILabel()
        label.text = NSLocalizedString("Readme:", comment: "Repos page")
        Designer.mainTitleLabel(label)
        stack.addArrangedSubview(label)
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        stack.addArrangedSubview(webView)
        webView.scrollView.isScrollEnabled = false
        webViewFirstLoadingComplete = false
    }
    
    @objc private func starRepository(){
        presenter?.starRepository()
    }
    
    @objc private func showIssues(){
        presenter?.showIssues()
    }
    
    @objc private func showBranches(){
        presenter?.showBranches()
    }
    
    func setReadme(base: String) {
        webView.loadHTMLString(base, baseURL: nil)
        loading.hide()
    }
    
    private func setupLoading(){
        view.addSubview(loading)
        loading.setMargin(0)
        loading.show(animation: false)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if webViewFirstLoadingComplete {
            if let url = navigationAction.request.url{
                UIApplication.shared.open(url)
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
            webViewFirstLoadingComplete.toggle()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { (height, error) in
            if  let h = height as? CGFloat{
                self.webView.heightAnchor.constraint(equalToConstant: h).isActive = true
            }
        })
    }
}
