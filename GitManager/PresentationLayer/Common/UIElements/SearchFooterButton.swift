//
//  SearchFooter.swift
//  GitManager
//
//  Created by Антон Текутов on 15.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class SearchFooterButton: UIView {
    let label = UILabel()
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNotFiltering() {
        label.text = "test text"
        hideFooter()
    }
    
    func setTextAndShow(text: String) {
        label.text = text
        showFooter()
    }
    
    func hideFooter() {
        UIView.animate(withDuration: 0.7) {
            self.alpha = 0.0
        }
    }
    
    func showFooter() {
        UIView.animate(withDuration: 0.7) {
            self.alpha = 1.0
        }
    }
    
    func configureView() {
        backgroundColor = Colors.mainColor
        self.alpha = 1.0
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.textAlignment = .center
        label.textColor = Colors.lightText
    }
}
