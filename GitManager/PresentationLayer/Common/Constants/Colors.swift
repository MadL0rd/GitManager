//
//  Colors.swift
//  GitManager
//
//  Created by Антон Текутов on 06.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

struct Colors {
    static let mainBackground : UIColor = .white
    static let backgroundDark : UIColor = .darkGray
    static let mainColor = UIColor("#4C16C0")
    static let mainColorWithAlpha = mainColor.withAlphaComponent(0.6)
    
    static let shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    static let folder = #colorLiteral(red: 1, green: 0.7117738161, blue: 0, alpha: 1)
    static let file = #colorLiteral(red: 0.5764705882, green: 0.3529411765, blue: 1, alpha: 1)
    
    static let lightGray = UIColor.lightGray

    static let error = #colorLiteral(red: 0.9033069349, green: 0.08879107483, blue: 0.127208709, alpha: 1)
    static let disable = UIColor("#9D9B9C")
    static let active = mainColor
    static let greenButton = UIColor("#51C627")
    static let redButton = error
    
    static let lightText : UIColor = .white
    static let darkText : UIColor = .black
    static let disableText = disable
    
    static let addictionalInfoText : UIColor = .white
    static let addictionalInfoPublic : UIColor = greenButton
    static let addictionalInfoPrivate : UIColor = error
    static let addictionalInfoLanguage : UIColor = UIColor("#2975C0")
    static let addictionalInfoIssue : UIColor = UIColor("#43C577")
    static let addictionalInfoStargazers : UIColor = UIColor("#00D455")
    
    static let selfComment = UIColor("#CEC0EE")
    static let otherComment = UIColor("#B2EDD2")
    
    static let ownerInfoBackground = mainColor
}
