//
//  LoadingView.swift
//  GitManager
//
//  Created by Антон Текутов on 04.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class LoadingView: UIView, LoadingViewProtocol {
    
    var duration: Double = 0.5
    var delayTime: Double = 1.1
    var animationActive = false
    var ellipsesQuantity = 7
    private var ellipses = [UIView]()
    private var colors = [UIColor]()
    private var positions = [(xPosition: Double, yPosition: Double)]()
    private var constraintsEllipses = [NSLayoutConstraint]()
    private var circleRadius: Double = 50
    private var ellipseRadius: CGFloat = 10
    private var currentPositionIndex = 0
    private let maxColorValue = 0.8
    private let minColorValue = 0.2
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(animation: Bool) {
        if animation{
            UIView.animate(withDuration: duration, animations: {
                self.alpha = 1
            })
        } else {
            alpha = 1
        }
        animationActive = true
        perform(#selector(startAnimation), with: nil, afterDelay: delayTime)
    }
    
    func hide(animation: Bool) {
        if animation{
            UIView.animate(withDuration: duration, animations: {
                self.alpha = 0
            })
        } else {
            alpha = 0
        }
        animationActive = false
    }
    
    func setDuration(duration: Double) {
        self.duration = duration
    }
    
    func setCircleRadius(radius: Double) {
        circleRadius = radius
        setup()
    }
    
    func setItemRadius(radius: Double) {
        ellipseRadius = CGFloat(radius)
        setup()
    }
    
    func setItemsQuantity(quantity: Int) {
        ellipsesQuantity = quantity
        setup()
    }
    
    private func setup() {
        delayTime *= duration
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Colors.mainBackground
        alpha = 0
        
        for i in 0...ellipsesQuantity-1 {
            var r = minColorValue, g = minColorValue, b = minColorValue
            let part = Double(i)*6/Double(ellipsesQuantity)
            switch part {
            case 0...1:
                r = maxColorValue
                g = minColorValue + (maxColorValue - minColorValue) * part
                b = minColorValue
            case 1...2:
                r = maxColorValue - (maxColorValue - minColorValue) * (part - 1)
                g = maxColorValue
                b = minColorValue
            case 2...3:
                r = minColorValue
                g = maxColorValue
                b = minColorValue + (maxColorValue - minColorValue) * (part - 2)
            case 3...4:
                r = minColorValue
                g = maxColorValue - (maxColorValue - minColorValue) * (part - 3)
                b = maxColorValue
            case 4...5:
                r = minColorValue + (maxColorValue - minColorValue) * (part - 4)
                g = minColorValue
                b = maxColorValue
            case 5...6:
                r = maxColorValue
                g = minColorValue
                b = maxColorValue - (maxColorValue - minColorValue) * (part - 5)
            default: break
            }
            colors.append(UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: 1))
        }
        
        let angleDelta: Double = Double.pi*2/Double(ellipsesQuantity)
        var currentAngle: Double = 0.0
        for i in 0...ellipsesQuantity - 1{
            let y = cos(currentAngle)*circleRadius
            let x = sin(currentAngle)*circleRadius
            
            let ellips = makeEllips()
            ellipses.append(ellips)
            addSubview(ellips)
            ellips.backgroundColor = colors[i]
            constraintsEllipses.append(ellips.centerYAnchor.constraint(equalTo: centerYAnchor, constant: CGFloat(y)))
            constraintsEllipses.append(ellips.centerXAnchor.constraint(equalTo: centerXAnchor, constant: CGFloat(x)))
            positions.append((xPosition: x, yPosition: y))
            currentAngle += angleDelta
        }
        for constraint in constraintsEllipses {
            constraint.isActive = true
        }
    }
    
    private func makeEllips() -> UIView{
        let ellips = UIView()
        ellips.translatesAutoresizingMaskIntoConstraints = false
        ellips.heightAnchor.constraint(equalToConstant: ellipseRadius*2).isActive = true
        ellips.widthAnchor.constraint(equalToConstant: ellipseRadius*2).isActive = true
        ellips.layer.cornerRadius = ellipseRadius
        ellips.backgroundColor = .green
        return ellips
    }
    
    @objc private func startAnimation(){
        if animationActive{
            for constraint in constraintsEllipses {
                constraint.isActive = false
            }
            constraintsEllipses.removeAll()
            currentPositionIndex = (currentPositionIndex + 1) % ellipsesQuantity
            for ellips in ellipses {
                let y = positions[currentPositionIndex].yPosition
                let x = positions[currentPositionIndex].xPosition
                constraintsEllipses.append(ellips.centerYAnchor.constraint(equalTo: centerYAnchor, constant: CGFloat(y)))
                constraintsEllipses.append(ellips.centerXAnchor.constraint(equalTo: centerXAnchor, constant: CGFloat(x)))
                
                currentPositionIndex = (currentPositionIndex + 1) % ellipsesQuantity
            }
            for constraint in constraintsEllipses {
                constraint.isActive = true
            }
            
            UIView.animate(withDuration: duration, animations: {
                for ellips in self.ellipses {
                    ellips.backgroundColor = self.colors[self.currentPositionIndex]
                    self.currentPositionIndex = (self.currentPositionIndex + 1) % self.ellipsesQuantity
                }
                self.layoutIfNeeded()
            })
            perform(#selector(startAnimation), with: nil, afterDelay: delayTime)
        } else {
            for constraint in constraintsEllipses {
                constraint.isActive = false
            }
            constraintsEllipses.removeAll()
            currentPositionIndex = (currentPositionIndex + 1) % ellipsesQuantity
            for ellips in ellipses {
                constraintsEllipses.append(ellips.centerYAnchor.constraint(equalTo: centerYAnchor))
                constraintsEllipses.append(ellips.centerXAnchor.constraint(equalTo: centerXAnchor))
                
                currentPositionIndex = (currentPositionIndex + 1) % ellipsesQuantity
            }
            for constraint in constraintsEllipses {
                constraint.isActive = true
            }
            UIView.animate(withDuration: duration, animations: {
                for ellips in self.ellipses {
                    ellips.backgroundColor = self.colors[self.currentPositionIndex]
                    self.currentPositionIndex = (self.currentPositionIndex + 1) % self.ellipsesQuantity
                }
                self.layoutIfNeeded()
            })
        }
    }
}
