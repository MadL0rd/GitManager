//
//  UIView+LayerAnimation.swift
//  GitManager
//
//  Created by Антон Текутов on 10.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

extension UIView {
    
    func animateLayer<Value>(_ keyPath: WritableKeyPath<CALayer, Value>, to value: Value, duration: CFTimeInterval) {
        let keyString = NSExpression(forKeyPath: keyPath).keyPath
        let animation = CABasicAnimation(keyPath: keyString)
        animation.fromValue = layer[keyPath: keyPath]
        animation.toValue = value
        animation.duration = duration
        layer.add(animation, forKey: animation.keyPath)
        var thelayer = layer
        thelayer[keyPath: keyPath] = value
    }
}
