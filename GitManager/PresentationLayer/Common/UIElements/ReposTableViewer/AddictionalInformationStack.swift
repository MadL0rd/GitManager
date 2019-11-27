//
//  addictionalInformationStack.swift
//  GitManager
//
//  Created by Антон Текутов on 29.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class AddictionalInformationStack: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(){
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        spacing = 3
        distribution = .fill
        alignment = .fill
    }
    
    private func createItem(color: UIColor, text: String) -> UILabel{
        let ul = UILabel()
        ul.text = text
        ul.textColor = Colors.lightText
        ul.layer.cornerRadius = 10
        ul.layer.backgroundColor = color.cgColor
        ul.layer.masksToBounds = true
        ul.translatesAutoresizingMaskIntoConstraints = false
        return ul
    }
    
    func setContent(repos : Repository, mode : AddictionalInfoContentMode = .Default){
        switch mode {
        case .Search:
            setContentSearch(repos: repos)
        case .Default:
            setContentDefault(repos: repos)
        case .Full:
            setContentFull(repos: repos)
        }
    }
    
    func setContentFull(repos : Repository){
        self.removeAllArrangedSubviews()
        var item : UILabel
        if repos.privateAccess{
            item = createItem(color: Colors.addictionalInfoPrivate, text: "  Private  ")
            addArrangedSubview(item)
        }else{
            item = createItem(color: Colors.addictionalInfoPublic, text: "  Public  ")
            addArrangedSubview(item)
        }
        if let lang = repos.language {
            item = createItem(color: Colors.addictionalInfoLanguage, text: "  \(lang)  ")
            addArrangedSubview(item)
        }
        item = createItem(color: Colors.addictionalInfoIssue, text: "  Issues: \(repos.openIssuesCount)  ")
        addArrangedSubview(item)
        item = createItem(color: Colors.addictionalInfoStargazers, text: "  ★\(repos.stargazersCount)  ")
        addArrangedSubview(item)
    }
    
    func setContentDefault(repos : Repository){
        self.removeAllArrangedSubviews()
        if repos.privateAccess{
            addArrangedSubview(createItem(color: Colors.addictionalInfoPrivate, text: "  Private  "))
        }else{
            addArrangedSubview(createItem(color: Colors.addictionalInfoPublic, text: "  Public  "))
        }
        if let lang = repos.language {
            addArrangedSubview(createItem(color: Colors.addictionalInfoLanguage, text: "  \(lang)  "))
        }
        addArrangedSubview(createItem(color: Colors.addictionalInfoIssue, text: "  Issues: \(repos.openIssuesCount)  "))
    }
    
    func setContentSearch(repos : Repository){
        self.removeAllArrangedSubviews()
        if let lang = repos.language {
            addArrangedSubview(createItem(color: Colors.addictionalInfoLanguage, text: "  \(lang)  "))
        }
        addArrangedSubview(createItem(color: Colors.addictionalInfoStargazers, text: "  ★\(repos.stargazersCount)  "))
    }
}

enum AddictionalInfoContentMode {
    case Default
    case Search
    case Full
}
