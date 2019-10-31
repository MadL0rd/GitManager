//
//  CustomTextField.swift
//  GitManager
//
//  Created by Антон Текутов on 19.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

  override init(frame: CGRect) {
        super.init(frame: frame)
        setUpField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init( coder: aDecoder )
        setUpField()
    }
    
    private func setUpField() {
        tintColor               = .white
        textColor               = .darkGray
        backgroundColor         = .white
        autocorrectionType      = .no
        borderStyle             = .roundedRect

        translatesAutoresizingMaskIntoConstraints = false
    }
}
