//
//  ProfileEditorInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 28.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class ProfileEditorInteractor: ProfileEditorInteractorProtocol {
    
    var presenter: ProfileEditorPresenterProtocol?
    var apiService: GitHubApiServiceProtocol?
    var keychain:   KeychainServiceProtocol?
    var multiRequestBlocker = true
    
    func getUserProfile() {
        if multiRequestBlocker {
            multiRequestBlocker = false
            apiService?.getAuthenticatedUser(callBack: sendUserProfile(user:))
        }
    }
    
    func sendUserProfile(user: GitUser) {
        multiRequestBlocker = true
        presenter?.userProfileDidFetch(user: user)
    }
    
    func patchUserProfile(newUserData: GitUser) {
        if multiRequestBlocker {
            multiRequestBlocker = false
            apiService?.editUserProfile(newUserData: newUserData, callBack: sendUserProfile(user:))
        }
    }
    
    func clearUserData(){
        keychain?.clearPrivateUserData()
    }
}
