//
//  MenuRowTableViewCell.swift
//  GitManager
//
//  Created by Антон Текутов on 10.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

class MenuRowTableViewCell: UITableViewCell {
    
    static let identifier = "MenuRowTableViewCell"
    
    let icon = UIImageView()
    let title = UILabel()
    let spacing: CGFloat = 10
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private setup methods
    
    private func setupView() {
        
        contentView.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        Designer.subTitleLabel(title)
        
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            
            icon.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: spacing),
            icon.heightAnchor.constraint(equalToConstant: 20),
            icon.widthAnchor.constraint(equalTo: icon.heightAnchor),
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: spacing * 2),
        	title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -spacing),
        ])
    }
}
