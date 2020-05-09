//
//  RepositoryTableViewCell.swift
//  GitManager
//
//  Created by Антон Текутов on 21.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class RepositoryTableViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let profileImageView = UIImageView()
    let addictionalInfo = AddictionalInformationStack()
    let starButton = TwoStateButton()
    var addictionalContentMode = AddictionalInfoContentMode.Default
    static let cellHeight : CGFloat = 100
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = Colors.mainBackground
        heightAnchor.constraint(equalToConstant: RepositoryTableViewCell.cellHeight).isActive = true
        
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(addictionalInfo)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(starButton)
        
        configureProfileImage()
        configureNameLabel()
        configureAddictionalInfo()
        configureStarButton()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }
    
    private func configureProfileImage(){
        profileImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5).isActive = true
        profileImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.8).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.8).isActive = true
        profileImageView.backgroundColor = Colors.backgroundDark
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = RepositoryTableViewCell.cellHeight * 0.8 / 2
        profileImageView.layer.masksToBounds = true
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNameLabel() {
        Designer.mainTitleLabelNormal(nameLabel)
        nameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -RepositoryTableViewCell.cellHeight/6).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: RepositoryTableViewCell.cellHeight).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -RepositoryTableViewCell.cellHeight/2).isActive = true
        nameLabel.textAlignment = .left
        nameLabel.lineBreakMode = .byCharWrapping
        nameLabel.numberOfLines = 1
        nameLabel.adjustsFontSizeToFitWidth = true
    }
    
    private func configureAddictionalInfo(){
        addictionalInfo.alignment = .trailing
        addictionalInfo.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: RepositoryTableViewCell.cellHeight/4).isActive = true
        addictionalInfo.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: RepositoryTableViewCell.cellHeight * 0.9).isActive = true
        addictionalInfo.heightAnchor.constraint(equalToConstant: RepositoryTableViewCell.cellHeight/4).isActive = true
        addictionalInfo.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureStarButton(){
        starButton.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -RepositoryTableViewCell.cellHeight/8).isActive = true
        if UIScreen.main.bounds.width > 370 {
            starButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        } else {
            starButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        }
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
