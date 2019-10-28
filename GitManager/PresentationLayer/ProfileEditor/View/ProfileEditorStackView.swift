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
        label.text = NSLocalizedString("Name", comment: "Title on profile editor screen")
        return label
    }()
    let nameTextField : UITextField = {
        let textField = CustomTextField()
        return textField
    }()
    let companyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Company", comment: "Title on profile editor screen")
        return label
    }()
    let companyTextField : UITextField = {
        let textField = CustomTextField()
        return textField
    }()
    let bioLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Biography", comment: "Title on profile editor screen")
        return label
    }()
    let bioTextField : UITextField = {
        let textField = CustomTextField()
        return textField
    }()
    let saveButton: CustomButton = {
        let btn = CustomButton()
        btn.setChangingText(active:     NSLocalizedString("Save", comment: "profile editor screen"),
                            blocked:    NSLocalizedString("There is no changes", comment: "profile editor screen"))
        btn.setBlocked()
        return btn
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
        addArrangedSubview(saveButton)
    }
    
    func textFieldsNeedsToSave()-> Bool{
        return  user.name != nameTextField.text &&
                user.company != companyTextField.text &&
                user.bio != bioTextField.text
    }
}
