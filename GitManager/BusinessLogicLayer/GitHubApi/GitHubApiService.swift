//
//  GitHubApiService.swift
//  GitManager
//
//  Created by Антон Текутов on 18.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import Foundation
import Alamofire

class GitHubApiService: GitHubApiServiceProtocol {
   
    private let apiUrl = "https://api.github.com/"
    static private var headers : HTTPHeaders = [:]
    
    private func _parseJsonResponse(data: Data) -> Any?
    {
        var jsonResponse: Any? = nil
        do
        {
            jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
        }
        catch let parsingError
        {
            print(parsingError.localizedDescription)
        }
        return jsonResponse
    }
    
    func getRepositories(callback : @escaping(_ repositories : [Repository])-> Void){
        var repositories = [Repository]()
        Alamofire.request(apiUrl + "user/repos",
                          headers: GitHubApiService.headers)
        .responseJSON{ response in
            if let data = response.data, let dataJson = self._parseJsonResponse(data: data) as? NSArray{
                for jsonItem in dataJson{
                    repositories.append(Repository(jsonItem as? NSDictionary))
                }
            }
            callback(repositories)
        }
    }
    
    func getStarredRepositories(callback : @escaping(_ repositories : [Repository])-> Void){
        var repositories = [Repository]()
        Alamofire.request(apiUrl + "user/starred",
                          headers: GitHubApiService.headers)
        .responseJSON{ response in
            if let data = response.data, let dataJson = self._parseJsonResponse(data: data) as? NSArray{
                for jsonItem in dataJson{
                    repositories.append(Repository(jsonItem as? NSDictionary))
                }
            }
            callback(repositories)
        }
    }
    
    func authenticate(login: String, password: String, callback: @escaping(_ success : Bool) -> Void) {
        let base64 = (login + ":" + password).toBase64()
        GitHubApiService.headers = ["Authorization": "Basic \(base64)"]
        Alamofire.request(apiUrl + "user",
                          headers: GitHubApiService.headers)
        .responseJSON{ response in
            guard let data = response.data, let dataJson = self._parseJsonResponse(data: data) as? NSDictionary
                else {callback(false); return}
            guard dataJson["login"] as? String != nil
                else {callback(false); return}
            callback(true)
        }
    }
    
    func editUserProfile(newUserData: GitUser, callback: @escaping (_ user : GitUser) -> Void) {
        let parametrs = [   "name" :    newUserData.name,
                            "company" : newUserData.company,
                            "bio":      newUserData.bio     ]
        Alamofire.request(apiUrl + "user",
                          method: .patch,
                          parameters: parametrs,
                          encoding: Alamofire.JSONEncoding.default,
                          headers: GitHubApiService.headers)
        .responseJSON{ [unowned self] response in
            if let data = response.data, let dataJson = self._parseJsonResponse(data: data) as? NSDictionary{
                let user = GitUser(dataJson)
                callback(user)
            }
        }
    }
    
    func getAuthenticatedUser(callback: @escaping (GitUser) -> Void) {
        Alamofire.request(apiUrl + "user", headers: GitHubApiService.headers)
        .responseJSON{ response in
            if let data = response.data, let dataJson = self._parseJsonResponse(data: data) as? NSDictionary{
                let user = GitUser(dataJson)
                callback(user)
            }
        }
    }
    
    func getPublicUserInfo(login: String, callback: @escaping (GitUser) -> Void) {
        Alamofire.request(apiUrl + "users/\(login)")
        .responseJSON{ response in
            if let data = response.data, let dataJson = self._parseJsonResponse(data: data) as? NSDictionary{
                let user = GitUser(dataJson)
                callback(user)
            }
        }
    }
    
    func starRepository(repository: Repository, callback : @escaping(_ starredReposId: Int64?)-> Void) {
        let method = repository.starred == true ? HTTPMethod.delete : HTTPMethod.put
        Alamofire.request(apiUrl + "user/starred/" + repository.fullName,
                          method: method,
                          headers: GitHubApiService.headers)
        .responseJSON{ response in
            if response.result.isSuccess {
                callback(repository.id)
            }else{
                callback(nil)
            }
        }
    }
}

