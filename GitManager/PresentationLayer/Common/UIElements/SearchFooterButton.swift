//
//  SearchFooter.swift
//  GitManager
//
//  Created by Антон Текутов on 15.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class SearchFooterButton: UIButton {
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextAndShow(text: String) {
        setTitle(text, for: .normal)
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
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = Colors.lightText.cgColor
        self.alpha = 0.0
    }
}
