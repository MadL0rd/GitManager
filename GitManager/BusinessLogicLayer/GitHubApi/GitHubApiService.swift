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
    
    func getRepositories(callBack : @escaping(_ repositories : [Repository])-> Void){
                
        var repositories = [Repository]()
        Alamofire.request("https://api.github.com/user/repos", headers: GitHubApiService.headers)
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
        
        Alamofire.request("https://api.github.com/user", headers: GitHubApiService.headers)
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
