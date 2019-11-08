//
//  CustomButton.swift
//  GitManager
//
//  Created by Антон Текутов on 19.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class TwoStateButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private let activeColor  = Colors.active
    private let blockedColor = Colors.disable
    private var activeText = ""
    private var blockedText = ""
    private var viewState = true //active - true, blocker - false
    private var textChanging = false
    private var interactionAbilityChanging = true
    
    private func setupButton() {
        layer.cornerRadius      = 9
        setTitleColor(Colors.lightText, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        setActive()
    }
    
    public func setInteractionAbilityChanging(changeByStates : Bool){
        interactionAbilityChanging = changeByStates
        if !interactionAbilityChanging{
            isUserInteractionEnabled = true
        }
        if interactionAbilityChanging && viewState{
            setBlocked()
        }
    }
    
    func setActive() {
        viewState = true
        if textChanging {
            setTitle(activeText, for: .normal)
        }
        isUserInteractionEnabled = true
        backgroundColor = activeColor
    }
    
    func setBlocked(){
        viewState = false
        if textChanging {
            setTitle(blockedText, for: .normal)
        }
        if interactionAbilityChanging{
            isUserInteractionEnabled = false
        }
        backgroundColor = blockedColor
    }
    
    func setChangingText(active: String, blocked: String){
        activeText = active
        blockedText = blocked
        textChanging = true
        if viewState {
            setActive()
        }else{
            setBlocked()
        }
    }
    
    func disableTextChanging(){
        textChanging = false
    }
}
