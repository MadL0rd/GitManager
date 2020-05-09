//
//  DirectoryCollectionViewCell.swift
//  GitManager
//
//  Created by Антон Текутов on 05.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

class DirectoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DirectoryCollectionViewCell"
    
    let icon = UIImageView()
    let title = UILabel()
    
    private let backIcon = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Public methods
    
    func setContent(_ dir: Directory) {
        switch dir.type {
        case .file:
            icon.image = #imageLiteral(resourceName: "file").withRenderingMode(.alwaysTemplate)
            contentView.backgroundColor = Colors.file
        case .branch: 
            icon.image = #imageLiteral(resourceName: "branch").withRenderingMode(.alwaysTemplate)
            contentView.backgroundColor = Colors.folder
        default:
            icon.image = #imageLiteral(resourceName: "folder").withRenderingMode(.alwaysTemplate)
            contentView.backgroundColor = Colors.folder
        }
        title.text = dir.name
        
        backIcon.isHidden = true
    }
    
    func makeDesignPrevious() {
        contentView.backgroundColor = Colors.disable
        backIcon.isHidden = false
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        
        contentView.backgroundColor = Colors.mainColorWithAlpha
        contentView.layer.cornerRadius = 20
        
        contentView.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = Colors.mainBackground
        
        contentView.addSubview(backIcon)
        backIcon.translatesAutoresizingMaskIntoConstraints = false
        backIcon.image = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
        backIcon.tintColor = Colors.mainBackground
        
        contentView.addSubview(title)
        Designer.subTitleLabel(title)
        title.textColor = Colors.mainBackground
        title.numberOfLines = 2
        title.textAlignment = .center
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20),
            icon.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            icon.heightAnchor.constraint(equalToConstant: 50),
            icon.widthAnchor.constraint(equalToConstant: 50),
            
            title.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 5),
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            
            backIcon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            backIcon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5)
        ])
    }
}
