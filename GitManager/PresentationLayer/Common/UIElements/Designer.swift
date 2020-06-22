//
//  Decorator.swift
//  GitManager
//
//  Created by Антон Текутов on 06.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

public class Designer{
    
    public static func mainColorWithBorder(_ view: UIView) {
        view.backgroundColor = Colors.mainColorWithAlpha
        view.layer.borderColor = Colors.mainColor.cgColor
        view.layer.borderWidth = 3
    }
    
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
    
    public static func mainTitleLabel(_ label : UILabel, textColor: UIColor? = nil){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = textColor ?? Colors.darkText
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.minimumScaleFactor = 1
    }
    
    public static func mainTitleLabelNormal(_ label : UILabel, textColor: UIColor? = nil){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = textColor ?? Colors.darkText
        label.font = UIFont.systemFont(ofSize: 18)
        label.minimumScaleFactor = 1
    }
    
    public static func subTitleLabel(_ label : UILabel, textColor: UIColor? = nil){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = textColor ?? Colors.darkText
        label.font = label.font.withSize(14)
    }
    
    public static func bigTitleLabel(_ label : UILabel, textColor: UIColor? = nil){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = textColor ?? Colors.darkText
        label.font = UIFont.boldSystemFont(ofSize: 28)
    }
    
    public static func smallButton(_ button : UIButton){
        button.layer.cornerRadius = 9
        button.setTitleColor(Colors.lightText, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = Colors.mainColor
    }
    
    public static func borderedClearButton(_ button : UIButton, color: UIColor){
        button.layer.cornerRadius = 9
        button.setTitleColor(color, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = 2
    }
}
