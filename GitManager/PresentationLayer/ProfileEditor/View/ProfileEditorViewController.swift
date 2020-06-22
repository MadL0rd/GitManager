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
    private let form: ProfileEditorStackView = ProfileEditorStackView()
    private let loading: LoadingViewProtocol = LoadingView()
    private let scroll = UIScrollView()
    private var spacing : CGFloat = 20
    private var dataLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        presenter?.viewDidLoad()
    }
    
    func setupView(){
        self.hideKeyboardWhenTappedAround()
        navigationItem.title = NSLocalizedString("Profile editing", comment: "Title on profile editor screen")
        view.backgroundColor = Colors.mainBackground
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        setupScrollView()
        setupForm()
        setupLoading()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if  KeyboardConstants.height == nil {
                KeyboardConstants.height = keyboardSize.height
            }
        }
    }
    
    private func setupScrollView(){
        view.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scroll.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        scroll.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupForm(){
        scroll.addSubview(form)
        form.translatesAutoresizingMaskIntoConstraints = false
        form.axis = .vertical
        form.spacing = spacing
        form.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        form.setMargin(left: 0, top: spacing * 2, right: 0, bottom: spacing * 6)
        form.setMargin(horizontal: 0, vertical: spacing * 2)
        form.widthAnchor.constraint(equalTo: scroll.widthAnchor, multiplier: 0.65).isActive = true
        
        form.nameTextField.addTarget(self, action: #selector(dataCheck), for: .editingDidEnd)
        form.companyTextField.addTarget(self, action: #selector(dataCheck), for: .editingDidEnd)
        form.bioTextField.addTarget(self, action: #selector(dataCheck), for: .editingDidEnd)
        form.blogTextField.addTarget(self, action: #selector(dataCheck), for: .editingDidEnd)
        form.locationTextField.addTarget(self, action: #selector(dataCheck), for: .editingDidEnd)
        form.saveButton.addTarget(self, action: #selector(updateUserProfile), for: .touchUpInside)
        form.saveButton.isHidden = true
    }
    
    private func setupLoading(){
        view.addSubview(loading)
        loading.setMargin(0)
        if !dataLoaded {
            loading.show(animation: false)
        }
    }
    
    func showUserProfile(user : GitUser) {
        form.user = user
        form.nameTextField.text = user.name
        form.companyTextField.text = user.company
        form.bioTextField.text = user.bio
        form.blogTextField.text = user.blog
        form.locationTextField.text = user.location
        form.saveButton.setBlocked()
        dataLoaded = true
        loading.hide()
    }
    
    @objc func updateUserProfile() {
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
            updateUserProfile()
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
