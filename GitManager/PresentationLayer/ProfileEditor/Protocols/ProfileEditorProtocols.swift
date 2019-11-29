//
//  ProfileEditorProtocols.swift
//  GitManager
//
//  Created by Антон Текутов on 28.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//



protocol ProfileEditorViewProtocol: class {
    var presenter:  ProfileEditorPresenterProtocol?     { get set }
    
    func validationEmailError()
    func showUserProfile(user : GitUser)
}

protocol ProfileEditorPresenterProtocol: class {
    var interactor: ProfileEditorInteractorProtocol?    { get set }
    var view:       ProfileEditorViewProtocol?          { get set }
    var router:     ProfileEditorRouterProtocol?        { get set }
    
    func viewDidLoad()
    func userProfileDidFetch(user : GitUser)
    func updateUserProfile(newUserData : GitUser)
    func validationEmailError()
    func logOut()
}

protocol ProfileEditorInteractorProtocol: class {
    var presenter:  ProfileEditorPresenterProtocol?     { get set }
    var keychain:   KeychainServiceProtocol?            { get set }
    var apiService: GitHubApiServiceProtocol?           { get set }
    
    func getUserProfile()
    func sendUserProfile(user : GitUser)
    func patchUserProfile(newUserData : GitUser)
    func clearUserData()
}

protocol ProfileEditorRouterProtocol: class {
    func showAuthenticationScreen()
}

