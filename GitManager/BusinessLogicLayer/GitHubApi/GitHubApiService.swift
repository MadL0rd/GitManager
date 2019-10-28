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
    
    func getRepositories(callBack : @escaping(_ repositories : [Repository])-> Void){
        var repositories = [Repository]()
        Alamofire.request(apiUrl + "user/repos",
                          headers: GitHubApiService.headers)
        .responseJSON{ response in
            if let dataJson = self._parseJsonResponse(data: response.data!) as? NSArray{
                for jsonItem in dataJson{
                    repositories.append(Repository(jsonItem as? NSDictionary))
                }
                callBack(repositories)
            }
        }
    }
    
    func authentication(login: String, password: String, callBack: @escaping (Bool) -> Void) {
        let base64 = (login + ":" + password).toBase64()
        GitHubApiService.headers = ["Authorization": "Basic \(base64)"]
        Alamofire.request(apiUrl + "user",
                          headers: GitHubApiService.headers)
        .responseJSON{ response in
            if let dataJson = self._parseJsonResponse(data: response.data!) as? NSDictionary{
                let login = dataJson["login"] as? String
                if login == nil{
                    callBack(false)
                }else{
                    callBack(true)
                }
            }
        }
    }
    
    func editUserProfile(newUserData: GitUser, callBack: @escaping (_ user : GitUser) -> Void) {
        let parametrs = [   "name" :    newUserData.name,
                            "company" : newUserData.company,
                            "bio":      newUserData.bio     ]
        Alamofire.request(apiUrl + "user",
                          method: .patch,
                          parameters: parametrs,
                          encoding: Alamofire.JSONEncoding.default,
                          headers: GitHubApiService.headers)
        .responseJSON{ response in
            if let dataJson = self._parseJsonResponse(data: response.data!) as? NSDictionary{
                let user = GitUser(dataJson)
                callBack(user)
            }
        }
    }
    
    func getAuthenticatedUser(callBack: @escaping (GitUser) -> Void) {
        Alamofire.request(apiUrl + "user", headers: GitHubApiService.headers)
        .responseJSON{ response in
            if let dataJson = self._parseJsonResponse(data: response.data!) as? NSDictionary{
                let user = GitUser(dataJson)
                callBack(user)
            }
        }
    }
    
    func getPublicUserInfo(login: String, callBack: @escaping (GitUser) -> Void) {
        Alamofire.request(apiUrl + "users/\(login)")
        .responseJSON{ response in
            if let dataJson = self._parseJsonResponse(data: response.data!) as? NSDictionary{
                let user = GitUser(dataJson)
                callBack(user)
            }
        }
    }
}

extension GitHubApiService{
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
}

extension String {

    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}
