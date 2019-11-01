//
//  addictionalInformationStack.swift
//  GitManager
//
//  Created by Антон Текутов on 29.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class addictionalInformationStack: UIStackView {
    
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
        ul.layer.cornerRadius = 10
        ul.layer.backgroundColor = color.cgColor
        ul.text = text
        ul.textColor = .white
        ul.layer.cornerRadius = 10
        ul.layer.backgroundColor = color.cgColor
        ul.layer.masksToBounds = true
        ul.translatesAutoresizingMaskIntoConstraints = false
        return ul
    }
    func setContent(repos : Repository){
        if repos.privateAccess{
            addArrangedSubview(createItem(color: .red, text: "  Private  "))
        }else{
            addArrangedSubview(createItem(color: .green, text: "  Public  "))
        }
        if let lang = repos.language {
            addArrangedSubview(createItem(color: .blue, text: "  \(lang)  "))
        }
        addArrangedSubview(createItem(color: .gray, text: "  Issues: \(repos.openIssuesCount)  "))
    }
}
