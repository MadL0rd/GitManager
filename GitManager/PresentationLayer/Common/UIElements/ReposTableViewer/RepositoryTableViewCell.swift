//
//  RepositoryTableViewCell.swift
//  GitManager
//
//  Created by Антон Текутов on 21.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class RepositoryTabelViewCell: UITableViewCell {
    
    let nameLabel : UILabel = {
        let label = UILabel()
        Designer.mainTitleLabel(label)
        label.textAlignment = .center
        return label
    }()
    let profileImageView = UIImageView()
    let addictionalInfo = AddictionalInformationStack()
    let starButton = TwoStateButton()
    var addictionalContentMode = AddictionalInfoContentMode.Default
    var cellHeight : CGFloat = 100
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.mainBackground
        cellHeight = self.bounds.width/3
        
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(addictionalInfo)
        self.contentView.addSubview(starButton)
        
        configureProfileImage()
        configureNameLabel()
        configureAddictionalInfo()
        configureStarButton()
    }
    
    private func configureProfileImage(){
        profileImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.8).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.8).isActive = true
        profileImageView.backgroundColor = Colors.backgroundDark
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = cellHeight * 0.8 / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNameLabel() {
        nameLabel.textColor = Colors.darkText
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -cellHeight/6).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: cellHeight).isActive = true
        nameLabel.numberOfLines = 0
        nameLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func configureAddictionalInfo(){
        addictionalInfo.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: cellHeight/4).isActive = true
        addictionalInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: cellHeight * 0.9).isActive = true
        addictionalInfo.heightAnchor.constraint(equalToConstant: cellHeight/4).isActive = true
        addictionalInfo.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureStarButton(){
        starButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -cellHeight/8).isActive = true
        starButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        starButton.setInteractionAbilityChanging(changeByStates: false)
        starButton.setChangingText(active: "★", blocked: "✩")
        starButton.setBlocked()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showRepository(repos : Repository?) {
        guard let reposItem : Repository = repos else {return}
        nameLabel.text = reposItem.name
        profileImageView.downloadFromUrl(url: reposItem.owner?.avatarUrl ?? "")
        addictionalInfo.setContent(repos: reposItem, mode: addictionalContentMode)
        if reposItem.starred{
            starButton.setActive()
        }else{
            starButton.setBlocked()
        }
    }
}
