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
        tf.textColor = Colors.darkText
        tf.backgroundColor = Colors.mainBackground
        //tf.layer.cornerRadius = 10
        //tf.layer.borderWidth = 2
        tf.layer.borderColor = Colors.darkText.cgColor
        tf.autocorrectionType = .no
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public static func defaultTextViewStyle(_ tv : UITextView){
        tv.textColor = Colors.darkText
        tv.backgroundColor = Colors.mainBackground
        tv.layer.borderColor = Colors.darkText.cgColor
        tv.autocorrectionType = .yes
        tv.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public static func mainTitleLabel(_ label : UILabel){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.darkText
        label.font = label.font.withSize(18)
        label.minimumScaleFactor = 1
    }
    
    public static func subTitleLabel(_ label : UILabel){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.darkText
        label.font = label.font.withSize(14)
    }
    
    public static func bigTitleLabel(_ label : UILabel){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.darkText
        label.font = label.font.withSize(28)
    }
    
    public static func smallButton(_ button : UIButton){
        button.layer.cornerRadius = 9
        button.setTitleColor(Colors.lightText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Colors.mainColor
    }
}
