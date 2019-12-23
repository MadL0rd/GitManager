//
//  FiltersView.swift
//  GitManager
//
//  Created by Антон Текутов on 25.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class FiltersView: UIView, FiltersViewProtocol {
    
    let filters: FiltrationManagerProtocol = FiltrationManager()
    private var relationsUIFilters = Dictionary<Int, (group: String, parameter: String)>()
    private var applyAction: (() -> Void)? = nil
    private let scroll = UIScrollView()
    private let stack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = Colors.mainBackground
        setupScrollView()
        setupStackView()
    }
    
    func setApplyAction(action: @escaping () -> Void){
        applyAction = action
    }
    
    func drawUI() {
        relationsUIFilters.removeAll()
        stack.removeAllArrangedSubviews()
        
        let apply = UIButton()
        apply.setTitle(NSLocalizedString("Apply", comment: "Filtration"), for: .normal)
        Designer.smallButton(apply)
        apply.backgroundColor = Colors.greenButton
        apply.addTarget(self, action: #selector(applyButtonAction), for: .touchUpInside)
        stack.addArrangedSubview(apply)
        
        let stringGroups = filters.getAllStringParametersState()
        for group in stringGroups{
            let label = UILabel()
            label.text = group.key
            Designer.mainTitleLabel(label)
            stack.addArrangedSubview(label)
            for parameter in group.value{
                let stackview = UIStackView()
                stackview.axis = .vertical
                let labelParameter = UILabel()
                labelParameter.text = parameter.key
                Designer.subTitleLabel(labelParameter)
                stackview.addArrangedSubview(labelParameter)
                let textField = UITextField()
                Designer.defaultTextFieldStyle(textField)
                textField.text = parameter.value
                stackview.addArrangedSubview(textField)
                textField.addTarget(self, action: #selector(textFieldFilterChanged), for: .editingChanged)
                addRelation(elementUI: textField, group: group.key, parameter: parameter.key)
                stack.addArrangedSubview(stackview)
            }
        }
        
        let tagGroups = filters.getAllTagParametersState()
        for group in tagGroups{
            let label = UILabel()
            label.text = group.key
            Designer.mainTitleLabel(label)
            stack.addArrangedSubview(label)
            
            let substack = UIStackView()
            substack.axis = .horizontal
            substack.spacing = 10
            substack.alignment = .center
            substack.distribution = .fillEqually
            
            let dropButton = UIButton()
            Designer.smallButton(dropButton)
            dropButton.backgroundColor = Colors.redButton
            dropButton.setTitle(NSLocalizedString("Drop", comment: "Filtration"), for: .normal)
            dropButton.addTarget(self, action: #selector(dropAllTagGroupFilters), for: .touchUpInside)
            addRelation(elementUI: dropButton, group: group.key, parameter: "")
            substack.addArrangedSubview(dropButton)
            
            let setButton = UIButton()
            Designer.smallButton(setButton)
            setButton.backgroundColor = Colors.greenButton
            setButton.setTitle(NSLocalizedString("Set", comment: "Filtration"), for: .normal)
            setButton.addTarget(self, action: #selector(setAllTagGroupFilters), for: .touchUpInside)
            addRelation(elementUI: setButton, group: group.key, parameter: "")
            substack.addArrangedSubview(setButton)
            
            substack.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(substack)
            
            for tag in group.value{
                let button = TwoStateButton()
                button.setTitle(tag.key, for: .normal)
                button.setInteractionAbilityChanging(changeByStates: false)
                button.addTarget(self, action: #selector(tagButtonAction), for: .touchUpInside)
                button.setBlocked()
                if tag.value{
                    button.setActive()
                }
                addRelation(elementUI: button, group: group.key, parameter: tag.key)
                stack.addArrangedSubview(button)
            }
        }
    }
    
    private func setupScrollView(){
        addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.setMargin(0)
        scroll.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    private func setupStackView(){
        scroll.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.setMargin(baseView: scroll, left: 0, top: 20, right: 0, bottom: 0)
        stack.widthAnchor.constraint(equalTo: scroll.widthAnchor, multiplier: 0.8).isActive = true
        stack.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stack.axis = .vertical
        stack.spacing = 20
    }
    
    private func addRelation(elementUI: UIView, group: String, parameter: String){
        elementUI.tag = relationsUIFilters.count
        relationsUIFilters[elementUI.tag] = (group: group, parameter: parameter)
    }
    
    @objc private func tagButtonAction(sender: AnyObject) {
        guard let button = sender as? TwoStateButton else { return }
        guard let relation = relationsUIFilters[button.tag] else { return }
        if button.getViewState(){
            button.setBlocked()
        }else{
            button.setActive()
        }
        filters.setTagParameterState(name: relation.parameter, groupTitle: relation.group, value: button.getViewState())
    }
    
    @objc private func textFieldFilterChanged(sender: AnyObject){
        guard let tf = sender as? UITextField else { return }
        guard let relation = relationsUIFilters[tf.tag] else { return }
        filters.setStringParameterState(name: relation.parameter, groupTitle: relation.group, value: tf.text ?? "")
    }
    
    @objc private func applyButtonAction(){
        applyAction?()
    }
    
    @objc private func setAllTagGroupFilters(sender: AnyObject){
        guard let button = sender as? UIView else { return }
        guard let relation = relationsUIFilters[button.tag] else { return }
        filters.setAllTagsInGroup(groupTitle: relation.group)
        drawUI()
    }
    @objc private func dropAllTagGroupFilters(sender: AnyObject){
        guard let button = sender as? UIView else { return }
        guard let relation = relationsUIFilters[button.tag] else { return }
        filters.dropAllTagsInGroup(groupTitle: relation.group)
        drawUI()
    }
}
