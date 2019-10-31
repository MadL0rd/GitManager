//
//  ProfileEditorView.swift
//  GitManager
//
//  Created by Антон Текутов on 28.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ProfileEditorView: UIViewController, ProfileEditorViewProtocol {
    
    var presenter: ProfileEditorPresenterProtocol?
    let form: ProfileEditorStackView = {
        let view = ProfileEditorStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("Profile editing", comment: "Title on profile editor screen")
        let logOutString = NSLocalizedString("LogOut", comment: "on profile editor screen")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: logOutString, style: .plain, target: self, action: #selector(logOut))

        setupView()
        
        presenter?.viewDidLoad()
    }
    
    func setupView(){
        view.backgroundColor = .white
        
        view.addSubview(form)
        form.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65).isActive = true
        form.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        form.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        form.nameTextField.addTarget(self, action: #selector(dataCheck), for: .editingChanged)
        form.companyTextField.addTarget(self, action: #selector(dataCheck), for: .editingChanged)
        form.bioTextField.addTarget(self, action: #selector(dataCheck), for: .editingChanged)
        form.saveButton.addTarget(self, action: #selector(updateUserProfile), for: .touchUpInside)
    }
    
    func showUserProfile(user : GitUser) {
        form.user = user
        form.nameTextField.text = user.name
        form.companyTextField.text = user.company
        form.bioTextField.text = user.bio
        form.saveButton.setBlocked()
    }
    
    @objc func updateUserProfile(){
        var user = GitUser()
        user.name = form.nameTextField.text ?? ""
        user.company = form.companyTextField.text ?? ""
        user.bio = form.bioTextField.text ?? ""
        presenter?.updateUserProfile(newUserData: user)
    }
    
    @objc func dataCheck(){
        if form.textFieldsNeedsToSave(){
            form.saveButton.setBlocked()
        }else{
            form.saveButton.setActive()
        }
    }
    
    @objc func logOut(){
        presenter?.logOut()
    }
}
