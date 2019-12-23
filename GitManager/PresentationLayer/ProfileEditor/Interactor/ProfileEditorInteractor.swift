//
//  ProfileEditorInteractor.swift
//  GitManager
//
//  Created by Антон Текутов on 28.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import Foundation

class ProfileEditorInteractor: ProfileEditorInteractorProtocol {
    
    var presenter: ProfileEditorPresenterProtocol?
    var apiService: GitHubApiServiceProtocol?{
        didSet {
            getUserProfile()
        }
    }
    var keychain:   KeychainServiceProtocol?
    var multiRequestBlocker = true
    
    func getUserProfile() {
        guard let api = apiService else { return }
        if multiRequestBlocker {
            multiRequestBlocker = false
            api.getAuthenticatedUser(callback: sendUserProfile(user:))
        }
    }
    
    func sendUserProfile(user: GitUser) {
        multiRequestBlocker = true
        presenter?.userProfileDidFetch(user: user)
    }
    
    func patchUserProfile(newUserData: GitUser) {
        if multiRequestBlocker {
            multiRequestBlocker = false
            apiService?.editUserProfile(newUserData: newUserData, callback: sendUserProfile(user:))
        }
    }
    
    func clearUserData(){
        keychain?.clearPrivateUserData()
    }
    
    private func isValidEmail(emailStr:String) -> Bool {

        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
}
