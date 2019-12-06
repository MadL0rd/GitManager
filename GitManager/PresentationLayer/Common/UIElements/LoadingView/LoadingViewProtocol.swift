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
    func setDuration(duration: Double)
    func setCircleRadius(radius: Double)
    func setItemRadius(radius: Double)
    func setItemsQuantity(quantity: Int)
}

extension LoadingViewProtocol{
    func show(){
        show(animation: true)
    }
    
    func hide(){
        hide(animation: true)
    }
}
