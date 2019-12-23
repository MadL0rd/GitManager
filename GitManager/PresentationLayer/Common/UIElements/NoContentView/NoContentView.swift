//
//  NoContentView.swift
//  GitManager
//
//  Created by Антон Текутов on 13.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class NoContentView: UIView, NoContentViewProtocol {

    var visibility = true
    private var reloadAction : (()-> Void)?
    private let stack = UIStackView()
    let reloadButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Colors.mainBackground
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        stack.axis = .vertical
        stack.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        let label = UILabel()
        stack.addArrangedSubview(label)
        Designer.bigTitleLabel(label)
        label.text = NSLocalizedString("There is no content", comment: "No content label")
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Colors.disable
        label.lineBreakMode = .byWordWrapping
        
        stack.addArrangedSubview(reloadButton)
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        reloadButton.setTitle("↺", for: .normal)
        reloadButton.setTitleColor(Colors.disable, for: .normal)
        reloadButton.titleLabel?.font = .systemFont(ofSize: 40)
        reloadButton.alpha = 0
    }
    
    @objc func reload(){
        reloadAction?()
    }
    
    func setReloadAction(_ action: @escaping (() -> Void)) {
        reloadAction = action
        reloadButton.alpha = 1
    }
    
    func toggleDisplayingState(){
        visibility.toggle()
        if visibility {
            alpha = 1.0
        } else {
            alpha = 0.0
        }
    }
    
    func show(){
        if visibility == false {
            toggleDisplayingState()
        }
    }
    
    func hide(){
        if visibility{
            toggleDisplayingState()
        }
    }
}
