//
//  RepositoryTableViewCell.swift
//  GitManager
//
//  Created by Антон Текутов on 21.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class RepositoryTabelViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let profileImageView = UIImageView()
    let addictionalInfo = addictionalInformationStack()
    let starButton = twoStateButton()
    var cellHeight : CGFloat = 100
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        cellHeight = self.contentView.bounds.width / 3
        self.contentView.heightAnchor.constraint(equalToConstant: CGFloat(cellHeight)).isActive = true
        
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
        profileImageView.backgroundColor = .gray
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = cellHeight * 0.8 / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNameLabel() {
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -cellHeight/6).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: cellHeight).isActive = true
        nameLabel.numberOfLines = 0
        nameLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func configureAddictionalInfo(){
        addictionalInfo.layer.backgroundColor = UIColor.red.cgColor
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

        if addictionalInfo.arrangedSubviews.count == 0{
            addictionalInfo.setContent(repos: reposItem)
            /*for item in addictionalInfo.arrangedSubviews{
                item.heightAnchor.constraint(equalToConstant: cellHeight/4).isActive = true
            }*/
        }
        if reposItem.starred{
            starButton.setActive()
        }else{
            starButton.setBlocked()
        }
    }
}
