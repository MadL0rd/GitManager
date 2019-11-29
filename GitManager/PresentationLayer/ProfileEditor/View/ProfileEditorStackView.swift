//
//  ProfileEditorStackView.swift
//  GitManager
//
//  Created by Антон Текутов on 28.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ProfileEditorStackView: UIStackView {
    
    var user : GitUser = GitUser()

    let nameLabel: UILabel = {
        let label = UILabel()
        Designer.mainTitleLabel(label)
        label.text = NSLocalizedString("Name", comment: "Title on profile editor screen")
        return label
    }()
    let nameTextField : UITextField = {
        let textField = UITextField()
        Designer.defaultTextFieldStyle(textField)
        return textField
    }()
    let companyLabel: UILabel = {
        let label = UILabel()
        Designer.mainTitleLabel(label)
        label.text = NSLocalizedString("Company", comment: "Title on profile editor screen")
        return label
    }()
    let companyTextField : UITextField = {
        let textField = UITextField()
        Designer.defaultTextFieldStyle(textField)
        return textField
    }()
    let bioLabel: UILabel = {
        let label = UILabel()
        Designer.mainTitleLabel(label)
        label.text = NSLocalizedString("Biography", comment: "Title on profile editor screen")
        return label
    }()
    let bioTextField : UITextField = {
        let textField = UITextField()
        Designer.defaultTextFieldStyle(textField)
        return textField
    }()
    let blogLabel: UILabel = {
        let label = UILabel()
        Designer.mainTitleLabel(label)
        label.text = NSLocalizedString("Blog", comment: "Title on profile editor screen")
        return label
    }()
    let blogTextField : UITextField = {
        let textField = UITextField()
        Designer.defaultTextFieldStyle(textField)
        return textField
    }()
    let locationLabel: UILabel = {
        let label = UILabel()
        Designer.mainTitleLabel(label)
        label.text = NSLocalizedString("Location", comment: "Title on profile editor screen")
        return label
    }()
    let locationTextField : UITextField = {
        let textField = UITextField()
        Designer.defaultTextFieldStyle(textField)
        return textField
    }()
    let saveButton: TwoStateButton = {
        let btn = TwoStateButton()
        btn.setChangingText(active:     NSLocalizedString("Save", comment: "profile editor screen"),
                            blocked:    NSLocalizedString("There is no changes", comment: "profile editor screen"))
        btn.setBlocked()
        return btn
    }()
    let errorLabel: UILabel = {
        let label = UILabel()
        Designer.mainTitleLabel(label)
        label.textColor = Colors.error
        label.alpha = 0
        label.text = NSLocalizedString("Email is not valid!", comment: "Title on authentication form")
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        spacing = 20
        distribution = .fill
        alignment = .fill
        
        addArrangedSubview(nameLabel)
        addArrangedSubview(nameTextField)
        addArrangedSubview(companyLabel)
        addArrangedSubview(companyTextField)
        addArrangedSubview(bioLabel)
        addArrangedSubview(bioTextField)
        addArrangedSubview(blogLabel)
        addArrangedSubview(blogTextField)
        addArrangedSubview(locationLabel)
        addArrangedSubview(locationTextField)
        addArrangedSubview(saveButton)
        addArrangedSubview(errorLabel)
    }
    
    func textFieldsNeedsToSave()-> Bool{
        return  user.name != nameTextField.text ||
                user.company != companyTextField.text ||
                user.bio != bioTextField.text ||
                user.blog != blogTextField.text ||
                user.location != locationTextField.text
    }
}
