//
//  NoContentView.swift
//  GitManager
//
//  Created by Антон Текутов on 13.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class NoContentView: UIView {

    var visibility = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Colors.mainBackground
        
        let label = UILabel()
        addSubview(label)
        Designer.bigTitleLabel(label)
        label.text = NSLocalizedString("There is no content", comment: "No content label")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Colors.disable
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.lineBreakMode = .byWordWrapping
    }
    
    func toggleDisplayingState(){
        visibility.toggle()
        if visibility {
            alpha = 1.0
        } else {
            alpha = 0.0
        }
    }
    
    func show(){
        if visibility == false {
            toggleDisplayingState()
        }
    }
    
    func hide(){
        if visibility{
            toggleDisplayingState()
        }
    }
}
