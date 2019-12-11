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
    let form: ProfileEditorStackView = ProfileEditorStackView()
    private let scroll = UIScrollView()
    private var spacing : CGFloat = 20

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = NSLocalizedString("Profile editing", comment: "Title on profile editor screen")
        let logOutString = NSLocalizedString("LogOut", comment: "on profile editor screen")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: logOutString, style: .plain, target: self, action: #selector(logOut))

        setupView()
        
        presenter?.viewDidLoad()
    }
    
    func setupView(){
        view.backgroundColor = Colors.mainBackground
        
        setupScrollView()
        setupForm()
    }
    
    private func setupScrollView(){
        view.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.setMargin(baseView: view.safeAreaLayoutGuide, 0)
    }
    
    private func setupForm(){
        scroll.addSubview(form)
        form.translatesAutoresizingMaskIntoConstraints = false
        form.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.65).isActive = true
        form.nameTextField.addTarget(self, action: #selector(dataCheck), for: .editingChanged)
        form.companyTextField.addTarget(self, action: #selector(dataCheck), for: .editingChanged)
        form.bioTextField.addTarget(self, action: #selector(dataCheck), for: .editingChanged)
        form.blogTextField.addTarget(self, action: #selector(dataCheck), for: .editingChanged)
        form.locationTextField.addTarget(self, action: #selector(dataCheck), for: .editingChanged)
        form.saveButton.addTarget(self, action: #selector(updateUserProfile), for: .touchUpInside)
        form.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        form.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        form.axis = .vertical
        form.spacing = spacing
    }
    
    func showUserProfile(user : GitUser) {
        form.user = user
        form.nameTextField.text = user.name
        form.companyTextField.text = user.company
        form.bioTextField.text = user.bio
        form.blogTextField.text = user.blog
        form.locationTextField.text = user.location
        form.saveButton.setBlocked()
    }
    
    @objc func updateUserProfile(){
        var user = GitUser()
        user.name = form.nameTextField.text ?? ""
        user.company = form.companyTextField.text ?? ""
        user.bio = form.bioTextField.text ?? ""
        user.blog = form.blogTextField.text ?? ""
        user.location = form.locationTextField.text ?? ""
        presenter?.updateUserProfile(newUserData: user)
    }
    
    @objc func dataCheck(){
        if form.errorLabel.alpha != 0{
            UIView.animate(withDuration: 0.5) {
                self.form.errorLabel.alpha = 0
            }
        }
        if form.textFieldsNeedsToSave(){
            form.saveButton.setActive()
        }else{
            form.saveButton.setBlocked()
        }
    }
    
    @objc func logOut(){
        presenter?.logOut()
    }
    
    func validationEmailError() {
        showErrorMessage()
    }
    
    func showErrorMessage() {
        UIView.animate(withDuration: 0.5) {
            self.form.errorLabel.alpha = 1
        }
    }
}
