//
//  GradientView.swift
//  TaganrogAttractionsMap
//
//  Created by Антон Текутов on 14.04.2020.
//

import UIKit

class GradientView: UIView {

    private var colorsBuff: [UIColor]?
    let gradient: CAGradientLayer

    init(gradient: CAGradientLayer) {
        self.gradient = gradient
        super.init(frame: .zero)
        self.gradient.frame = self.bounds
        self.layer.insertSublayer(self.gradient, at: 0)
    }

    convenience init(colors: [UIColor], locations: [Float] = [0.0, 1.0]) {
        let gradient = CAGradientLayer()
        gradient.colors = colors.map { $0.cgColor }
        gradient.locations = locations.map { NSNumber(value: $0) }
        self.init(gradient: gradient)
        colorsBuff = colors
    }

    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if let colors = colorsBuff {
            gradient.colors = colors.map { $0.cgColor }
        }
        gradient.frame = bounds
    }

    required init?(coder: NSCoder) { 
        fatalError("no init(coder:)") 
    }
    
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

