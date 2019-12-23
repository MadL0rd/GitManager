//
//  IssueTableViewCell.swift
//  GitManager
//
//  Created by Антон Текутов on 11.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class IssueTableViewCell: UITableViewCell {
    
    static let cellHeight: CGFloat = 60
    var cellHeight: CGFloat{
        get{
            return IssueTableViewCell.cellHeight
        }
    }
    let stateLabel = UILabel()
    let titleLabel = UILabel()
    let infoLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = Colors.mainBackground
        
        let mainStack = UIStackView()
        contentView.addSubview(mainStack)
        mainStack.axis = .horizontal
        mainStack.spacing = cellHeight / 10
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        mainStack.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8).isActive = true
        mainStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        mainStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: cellHeight / 5).isActive = true
        mainStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -cellHeight / 5).isActive = true

        Designer.bigTitleLabel(stateLabel)
        stateLabel.textAlignment = .center
        stateLabel.layer.cornerRadius = cellHeight * 0.8 / 2
        stateLabel.layer.borderWidth = cellHeight * 0.05
        stateLabel.heightAnchor.constraint(equalToConstant: cellHeight * 0.8).isActive = true
        stateLabel.widthAnchor.constraint(equalToConstant: cellHeight * 0.8).isActive = true
        mainStack.addArrangedSubview(stateLabel)
        
        let substack = UIStackView()
        mainStack.addArrangedSubview(substack)
        substack.axis = .vertical
        substack.spacing = cellHeight / 10
        
        Designer.mainTitleLabel(titleLabel)
        substack.addArrangedSubview(titleLabel)
        
        Designer.subTitleLabel(infoLabel)
        substack.addArrangedSubview(infoLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setIssue(issue: Issue){
        titleLabel.text = issue.title
        if issue.open {
            stateLabel.layer.borderColor = Colors.addictionalInfoPrivate.cgColor
            stateLabel.textColor = Colors.addictionalInfoPrivate
            stateLabel.text = "!"
        } else {
            stateLabel.layer.borderColor = Colors.addictionalInfoPublic.cgColor
            stateLabel.textColor = Colors.addictionalInfoPublic
            stateLabel.text = "✓"
        }
        
        if let number = issue.number, let login = issue.user?.login{
            
            let opened = NSLocalizedString("opened on", comment: "issues info")
            let closed = NSLocalizedString("was closed on", comment: "issues info")
            let by = NSLocalizedString("by", comment: "issues info")
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy"
            
            if issue.open {
                infoLabel.text = "#\(number) \(opened) \(formatter.string(from: issue.createdAt)) \(by) \(login)"
            } else {
                infoLabel.text = "#\(number) \(by) \(login) \(closed) \(formatter.string(from: issue.closedAt))"
            }
        }
    }

}
