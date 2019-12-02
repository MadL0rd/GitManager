//
//  GitHubApiServiceProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 24.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

protocol GitHubApiServiceProtocol {
    
    func authenticate(login: String, password: String, callback : @escaping(_ success : Bool)-> Void)
    func getRepositories(itemsPerPage: Int, pageNumber : Int, callback : @escaping(_ repositories : [Repository])-> Void)
    func getStarredRepositories(itemsPerPage: Int, pageNumber : Int, callback : @escaping(_ repositories : [Repository])-> Void)
    func searchRepositories(name: String, language: String, itemsPerPage: Int, pageNumber : Int,  callback: @escaping ([Repository]) -> Void)
    func getAuthenticatedUser(callback : @escaping(_ user : GitUser)-> Void)
    func getPublicUserInfo(login: String, callback : @escaping(_ user : GitUser)-> Void)
    func editUserProfile(newUserData: GitUser, callback : @escaping(_ user : GitUser)-> Void)
    func starRepository(repository: Repository, callback : @escaping(_ starredRepository: Repository?)-> Void)
    func getReadme(repository: Repository, callback : @escaping(_ htmlSource : String?)-> Void)
}
