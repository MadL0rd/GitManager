//
//  Decorator.swift
//  GitManager
//
//  Created by Антон Текутов on 06.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

public class Designer{
    
    public static func defaultTextFieldStyle(_ tf : UITextField){
        tf.tintColor = Colors.mainBackground
        tf.textColor = Colors.darkText
        tf.backgroundColor = Colors.mainBackground
        tf.autocorrectionType = .no
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public static func defaultLabelStyle(_ label : UILabel){
        label.translatesAutoresizingMaskIntoConstraints = false
    }
}
