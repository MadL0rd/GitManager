//
//  AuthenticationView.swift
//  GitManager
//
//  Created by Антон Текутов on 19.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class AuthenticationStackView: UIStackView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Авторизация"
        label.textAlignment = .center
        return label
    }()
    let loginTextField : UITextField = {
        let textField = CustomTextField()
        textField.placeholder = "Логин"
        return textField
    }()
    let passwordTextField : UITextField = {
        let textField = CustomTextField()
        textField.placeholder = "Пароль"
        textField.isSecureTextEntry = true
        return textField
    }()
    let loginButton: CustomButton = {
        let btn = CustomButton()
        btn.setBlocked()
        btn.setTitle("Login", for: .normal)
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
        
        addArrangedSubview(titleLabel)
        addArrangedSubview(loginTextField)
        addArrangedSubview(passwordTextField)
        addArrangedSubview(loginButton)
    }
    
    func textFieldsCheck()-> Bool{
        if  loginTextField.text?.count ?? 0 > 0 &&
            passwordTextField.text?.count ?? 0 > 0 {
            return true
        }
        return false
    }
}
 
