//
//  LoadingViewProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 04.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

protocol LoadingViewProtocol: UIView{
    func show(animation: Bool)
    func hide(animation: Bool)
}

extension LoadingViewProtocol{
    func show(){
        show(animation: true)
    }
    
    func hide(){
        hide(animation: true)
    }
}
