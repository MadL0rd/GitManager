//
//  ButtonWithImage.swift
//  GitManager
//
//  Created by Антон Текутов on 07.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import UIKit

class ButtonWithStack: UIButton {
        
    let stack = UntouchableStackView()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 5

        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: centerYAnchor),
            stack.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}

