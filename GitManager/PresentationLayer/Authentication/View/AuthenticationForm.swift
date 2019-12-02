//
//  AuthenticationView.swift
//  GitManager
//
//  Created by Антон Текутов on 19.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class AuthenticationForm: UIStackView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        Designer.mainTitleLabel(label)
        label.text = NSLocalizedString("Authentication", comment: "Title on authentication form")
        label.textAlignment = .center
        return label
    }()
    let loginTextField : UITextField = {
        let textField = UITextField()
        Designer.defaultTextFieldStyle(textField)
        textField.placeholder = NSLocalizedString("Login", comment: "Text field on authentication form")
        return textField
    }()
    let passwordTextField : UITextField = {
        let textField = UITextField()
        Designer.defaultTextFieldStyle(textField)
        textField.placeholder = NSLocalizedString("Password", comment: "Text field on authentication form")
        textField.isSecureTextEntry = true
        return textField
    }()
    let loginButton: TwoStateButton = {
        let btn = TwoStateButton()
        btn.setBlocked()
        btn.setTitle(NSLocalizedString("Sign in", comment: "Button on authentication form"), for: .normal)
        return btn
    }()
    let errorLabel: UILabel = {
        let label = UILabel()
        Designer.mainTitleLabel(label)
        label.textColor = Colors.error
        label.alpha = 0
        label.text = NSLocalizedString("Pair login-password is wrong!", comment: "Title on authentication form")
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
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(loginTextField)
        addArrangedSubview(passwordTextField)
        addArrangedSubview(loginButton)
        addArrangedSubview(errorLabel)
    }
    
    func textFieldsIsNotEmpty()-> Bool{
        guard let login = loginTextField.text, let pass = passwordTextField.text else { return false }
        return !(login.isEmpty || pass.isEmpty)
    }
}
 
