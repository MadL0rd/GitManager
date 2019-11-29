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
    private var searchRequest : Request?
    private var searchRequestCount = 0
    
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
    
    func getRepositories(itemsPerPage: Int, pageNumber : Int, callback : @escaping(_ repositories : [Repository])-> Void){
        var repositories = [Repository]()
        Alamofire.request(apiUrl + "user/repos?page=\(pageNumber)&per_page=\(itemsPerPage)&sort=name",
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
    
    func getStarredRepositories(itemsPerPage: Int, pageNumber : Int, callback : @escaping(_ repositories : [Repository])-> Void){
        var repositories = [Repository]()
        Alamofire.request(apiUrl + "user/starred?page=\(pageNumber)&per_page=\(itemsPerPage)&sort=name",
                          headers: GitHubApiService.headers)
        .responseJSON{ response in
            if let data = response.data, let dataJson = self._parseJsonResponse(data: data) as? NSArray{
                for jsonItem in dataJson{
                    let repos = Repository(jsonItem as? NSDictionary)
                    //repos.starred = true
                    repositories.append(repos)
                }
            }
            callback(repositories)
        }
    }
    
    func searchRepositories(name: String, language: String, itemsPerPage: Int, pageNumber : Int,  callback: @escaping ([Repository]) -> Void){
        searchRequest?.cancel()
        searchRequest = nil
        searchRequestCount += 1
        let requestId = searchRequestCount
        var repositories = [Repository]()
        searchRequest = Alamofire.request(apiUrl + "search/repositories?q=\(name)+language:\(language)&page=\(pageNumber)&per_page=\(itemsPerPage)&sort=stars&order=desc",
                          headers: GitHubApiService.headers)
        .responseJSON{ response in
            if self.searchRequestCount == requestId{
                if let data = response.data, let dataJson = self._parseJsonResponse(data: data) as? NSDictionary,
                    let items = dataJson["items"] as? NSArray{
                    for jsonItem in items{
                        let repos = Repository(jsonItem as? NSDictionary)
                        repositories.append(repos)
                    }
                }
                callback(repositories)
                self.searchRequest = nil
            }
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
        let parameters = [  "name"    : newUserData.name,
                            "blog"    : newUserData.blog,
                            "company" : newUserData.company,
                            "location": newUserData.location,
                            "bio"     : newUserData.bio     ]
        Alamofire.request(apiUrl + "user",
                          method: .patch,
                          parameters: parameters as Parameters,
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
    
    func starRepository(repository: Repository, callback : @escaping(_ starredRepository: Repository?)-> Void) {
        let method = repository.starred == true ? HTTPMethod.delete : HTTPMethod.put
        Alamofire.request(apiUrl + "user/starred/" + repository.fullName,
                          method: method,
                          headers: GitHubApiService.headers)
        .responseJSON{ response in
            if response.result.isSuccess {
                callback(repository)
            }else{
                callback(nil)
            }
        }
    }
    
    func getReadme(repository: Repository, callback : @escaping(_ base64Readme : String?)-> Void){
        guard let url = repository.url else { return }
        Alamofire.request(url + "/readme")
        .responseJSON{ response in
            if let data = response.data, let dataJson = self._parseJsonResponse(data: data) as? NSDictionary{
                var readme = dataJson["html_url"] as? String
                callback(readme)
            }
        }
    }
}

