//
//  GitHubApiServiceProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 24.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

protocol GitHubApiServiceProtocol {
    
    func authenticate(login: String, password: String, callback : @escaping(_ success : Bool)-> Void)
    func getRepositories(callback : @escaping(_ repositories : [Repository])-> Void)
    func getStarredRepositories(callback : @escaping(_ repositories : [Repository])-> Void)
    func getAuthenticatedUser(callback : @escaping(_ user : GitUser)-> Void)
    func getPublicUserInfo(login: String, callback : @escaping(_ user : GitUser)-> Void)
    func editUserProfile(newUserData: GitUser, callback : @escaping(_ user : GitUser)-> Void)
    func starRepository(repository: Repository, callback : @escaping(_ starredRepository: Repository?)-> Void)
}
