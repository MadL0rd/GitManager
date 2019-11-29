//
//  ProfileEditorPresenter.swift
//  GitManager
//
//  Created by Антон Текутов on 28.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ProfileEditorPresenter: ProfileEditorPresenterProtocol {
    
    var interactor: ProfileEditorInteractorProtocol?
    var view: ProfileEditorViewProtocol?
    var router: ProfileEditorRouterProtocol?
    
    func viewDidLoad() {
        interactor?.getUserProfile()
    }
    
    func userProfileDidFetch(user: GitUser) {
        view?.showUserProfile(user: user)
    }
    
    func updateUserProfile(newUserData: GitUser) {
        interactor?.patchUserProfile(newUserData: newUserData)
    }
    
    func logOut(){
        interactor?.clearUserData()
        router?.showAuthenticationScreen()
    }
    
    func validationEmailError() {
        view?.validationEmailError()
    }
}
