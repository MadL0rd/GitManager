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
        self.alpha = 0.0
        layer.cornerRadius = 10
        //backgroundColor = Colors.mainColorWithAlpha
        Designer.mainColorWithBorder(self)
        
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UntouchableUIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.clipsToBounds = true
        blurEffectView.alpha = 0.9
        addSubview(blurEffectView)
    }
}
