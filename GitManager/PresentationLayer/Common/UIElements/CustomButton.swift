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
    
    private let active  = UIColor("#00D455FF")
    private let blocked = UIColor("#C0C0C0FF")
    
    private func setupButton() {
        layer.cornerRadius      = 9
        setTitleColor(.white, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        setActive()
    }
    
    func setActive() {
        isUserInteractionEnabled = true
        backgroundColor          = active
    }
    
    func setBlocked(){
        isUserInteractionEnabled = false
        backgroundColor          = blocked
    }
}
