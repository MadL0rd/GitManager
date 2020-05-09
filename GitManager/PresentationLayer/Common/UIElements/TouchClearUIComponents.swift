//
//  TouchClearUIView.swift
//  TaganrogAttractionsMap
//
//  Created by Антон Текутов on 09.04.2020.
//

import UIKit

class UntouchableStackView: UIStackView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return false
    }
}

class TouchClearUIStackView: UIStackView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let inside = super.point(inside: point, with: event)
        if inside {
            for subview in subviews {
                let pointInSubview = subview.convert(point, from: self)
                if subview.point(inside: pointInSubview, with: event) {
                    return true
                }
            }
        }
        
        return false
    }
}

class TouchClearUIScrollView: UIScrollView {
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let inside = super.point(inside: point, with: event)
        if inside {
            for subview in subviews {
                let pointInSubview = subview.convert(point, from: self)
                if subview.point(inside: pointInSubview, with: event) {
                    return true
                }
            }
        }
        
        return false
    }
}
