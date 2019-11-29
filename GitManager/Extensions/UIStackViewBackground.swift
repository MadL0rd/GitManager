//
//  UIsatckViewBackground.swift
//  GitManager
//
//  Created by Антон Текутов on 27.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

extension UIStackView {
    func setBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
