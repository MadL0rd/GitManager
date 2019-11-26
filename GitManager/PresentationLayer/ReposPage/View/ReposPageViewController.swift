//
//  ReposPageViewController.swift
//  GitManager
//
//  Created by Антон Текутов on 29.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit
import WebKit

class ReposPageView: UIViewController, ReposPageViewProtocol{
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
        descriptionText.text = repository.description
        
        if let url = URL(string: "https://github.com/\(repository.fullName)/blob/master/README.md"){
            webView.load(URLRequest(url: url))
        }
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
        scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true;
        scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true;
        scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true;
        scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true;
    }
    private func setupStackView(){
        scroll.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.leadingAnchor.constraint(equalTo: scroll.leadingAnchor).isActive = true;
        stack.topAnchor.constraint(equalTo: scroll.topAnchor, constant: width/20).isActive = true;
        stack.trailingAnchor.constraint(equalTo: scroll.trailingAnchor).isActive = true;
        stack.bottomAnchor.constraint(equalTo: scroll.bottomAnchor).isActive = true;
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
        titleStack.addArrangedSubview(starredButton)

        stack.addArrangedSubview(titleStack)
        
        addictionalInfo.distribution = .fillProportionally
        stack.addArrangedSubview(addictionalInfo)
        
        var label = UILabel()
        label.text = NSLocalizedString("Description:", comment: "Repos page")
        Designer.mainTitleLabel(label)
        stack.addArrangedSubview(label)
        Designer.mainTitleLabel(descriptionText)
        descriptionText.lineBreakMode = .byWordWrapping
        stack.addArrangedSubview(descriptionText)
        
        label = UILabel()
        label.text = NSLocalizedString("Readme:", comment: "Repos page")
        Designer.mainTitleLabel(label)
        stack.addArrangedSubview(label)
        webView.heightAnchor.constraint(equalToConstant: width).isActive = true
        stack.addArrangedSubview(webView)
    }
}
