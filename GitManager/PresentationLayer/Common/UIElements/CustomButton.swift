//
//  CustomButton.swift
//  GitManager
//
//  Created by Антон Текутов on 19.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private let activeColor  = UIColor("#00D455FF")
    private let blockedColor = UIColor("#C0C0C0FF")
    private var activeText = ""
    private var blockedText = ""
    private var textChanging = false
    
    private func setupButton() {
        layer.cornerRadius      = 9
        setTitleColor(.white, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        setActive()
    }
    
    func setActive() {
        if textChanging {
            setTitle(activeText, for: .normal)
        }
        isUserInteractionEnabled = true
        backgroundColor          = activeColor
    }
    
    func setBlocked(){
        if textChanging {
            setTitle(blockedText, for: .normal)
        }
        isUserInteractionEnabled = false
        backgroundColor          = blockedColor
    }
    
    func setChangingText(active: String, blocked: String){
        activeText = active
        blockedText = blocked
        textChanging = true
    }
    
    func disableTextChanging(){
        textChanging = false
    }
}
