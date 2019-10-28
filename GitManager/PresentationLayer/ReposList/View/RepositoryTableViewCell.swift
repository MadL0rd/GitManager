//
//  RepositoryTableViewCell.swift
//  GitManager
//
//  Created by Антон Текутов on 21.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class RepositoryTabelViewCell: UITableViewCell {
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(nameLabel)
        nameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: self.contentView.bounds.width / 8).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showRepository(repos : Repository?) {
        guard let reposItem : Repository = repos else {return}
        if let name = reposItem.name{
            nameLabel.text = name
        }
    }
}
