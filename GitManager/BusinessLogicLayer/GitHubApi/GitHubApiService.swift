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
    
    private let parser : FileParserProtocol = GitHubFileParser()
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
    
    func getReadme(repository: Repository, callback : @escaping(_ htmlSource : String?)-> Void) {
        guard let url = repository.url else { return }
        Alamofire.request(url + "/readme")
            .responseJSON{ response in
                if  let data = response.data,
                    let dataJson = self._parseJsonResponse(data: data) as? NSDictionary,
                    let readmeUrl = dataJson["html_url"] as? String{
                    Alamofire.request(readmeUrl)
                        .responseJSON{ response in
                            if let data = response.data{
                                guard let html = String(data: data, encoding: String.Encoding.utf8) else { return }
                                callback(self.parser.parsePageAsReadMe(htmlSource: html))
                            }
                    }
                } else {
                    callback("")
                }
        }
    }
    
    func getFileContent(repository: Repository, path: String, callback : @escaping(_ htmlSource : String?)-> Void) {
        guard let url = repository.url else { return }
        Alamofire.request(url + "/blob/" + path)
            .responseJSON{ response in
                if  let data = response.data,
                    let dataJson = self._parseJsonResponse(data: data) as? NSDictionary,
                    let readmeUrl = dataJson["html_url"] as? String{
                    Alamofire.request(readmeUrl)
                        .responseJSON{ response in
                            if let data = response.data{
                                guard let html = String(data: data, encoding: String.Encoding.utf8) else { return }
                                callback(self.parser.parsePageAsCodeFile(htmlSource: html))
                            }
                    }
                } else {
                    callback("")
                }
        }
    }

    
    func getBrancesList(repository: Repository, callback : @escaping(_ branches : [String])-> Void) {
        guard let url = repository.url else { return }
        var branches = [String]()
        Alamofire.request(url + "/branches", headers: GitHubApiService.headers)
            .responseJSON{ response in
                if  let data = response.data,
                    let dataJson = self._parseJsonResponse(data: data) as? NSArray {
                    for item in dataJson {
                        if 	let branch = item as? NSDictionary,
                            let branchName = branch["name"] as? String {
                            branches.append(branchName)
                        }
                    }
                } 
                callback(branches)
        }
    }
    
    func getBranchRootDirectory(repo: Repository, branch: String, callback: @escaping (Directory) -> Void) {
        guard let url = repo.url else { return }
        Alamofire.request(url + "/branches/\(branch)", headers: GitHubApiService.headers)
            .responseJSON{ response in
                if  let data = response.data,
                    let dataJson = self._parseJsonResponse(data: data) as? NSDictionary,
                    let commit = (dataJson["commit"] as? NSDictionary)?["commit"] as? NSDictionary,
                    let tree = commit["tree"] as? NSDictionary,
                    let treeUrl = tree["url"] as? String {
                    let rootDir = Directory(type: .branch, name: branch, url: treeUrl)
                    callback(rootDir)
                } 
        }
    }
    
    func getDirectoryContentByUrl(url: String, callback: @escaping ([Directory]) -> Void) {
        Alamofire.request(url, headers: GitHubApiService.headers)
            .responseJSON{ response in
                if  let data = response.data,
                    let dataJson = self._parseJsonResponse(data: data) as? NSDictionary,
                	let tree = dataJson["tree"] as? NSArray {
                    var directories = [Directory]()
                    for item in tree {
                        if	let dir = item as? NSDictionary,
                            let dirName = dir["path"] as? String,
                            let dirUrl = dir["url"] as? String,
                        	let dirTypeName = dir["type"] as? String {
                            var dirType = DirectoryType.file
                            switch dirTypeName {
                            case "blob":
                                dirType = .file
                            case "tree":
                                dirType = .folder
                            default:
                                dirType = .file
                            }
                            
                            let directory = Directory(type: dirType,
                                                      name: dirName, 
                                                      url: dirUrl)
                            directories.append(directory)
                        }
                    }
                    callback(directories)
                }
        }
    }
    
    func getIssues(repository: Repository, itemsPerPage: Int, pageNumber: Int, callback: @escaping (_ issues: [Issue]) -> Void) {
        Alamofire.request(apiUrl + "repos/\(repository.fullName)/issues?page=\(pageNumber)&per_page=\(itemsPerPage)&state=all",
            headers: GitHubApiService.headers)
            .responseJSON{ response in
                var issues = [Issue]()
                if let data = response.data, let dataJson = self._parseJsonResponse(data: data) as? NSArray{
                    for jsonItem in dataJson{
                        let issue = Issue(jsonItem as? NSDictionary)
                        issues.append(issue)
                    }
                }
                callback(issues)
        }
    }
    
    func createIssue(repository: Repository, title: String, callback : @escaping(_ issue : Issue)-> Void) {
        let parameters = [  "title": title,
                            "body": ""]
        Alamofire.request(apiUrl + "repos/\(repository.fullName)/issues",
            method: .post,
            parameters: parameters as Parameters,
            encoding: Alamofire.JSONEncoding.default,
            headers: GitHubApiService.headers)
            .responseJSON{ response in
                    if let data = response.data, let dataJson = self._parseJsonResponse(data: data) as? NSDictionary {
                        let issue = Issue(dataJson)
                        callback(issue)
                    }
            }
    }
    
    func getIssuesComments(issue: Issue, itemsPerPage: Int, pageNumber : Int, callback : @escaping(_ issues: [IssueComment])-> Void){
        guard let url = issue.url else {
            print("!!! WARNING !!! Incorrect issue url!")
            return
        }
        Alamofire.request(url + "/comments?page=\(pageNumber)&per_page=\(itemsPerPage)&state=all",
            headers: GitHubApiService.headers)
            .responseJSON{ response in
                var comments = [IssueComment]()
                if let data = response.data, let dataJson = self._parseJsonResponse(data: data) as? NSArray{
                    for jsonItem in dataJson{
                        let comment = IssueComment(jsonItem as? NSDictionary)
                        comments.append(comment)
                    }
                    callback(comments)
                }
        }
    }
    
    func addCommentToIssue(issue: Issue, comment: String, callback : @escaping(_ comment: IssueComment)-> Void){
        guard let url = issue.url else {
            print("!!! WARNING !!! Incorrect issue url!")
            return
        }
        
        let parameters = [  "body": comment ]
        Alamofire.request(url + "/comments",
            method: .post,
            parameters: parameters as Parameters,
            encoding: Alamofire.JSONEncoding.default,
            headers: GitHubApiService.headers)
            .responseJSON{ response in
                if let data = response.data, let dataJson = self._parseJsonResponse(data: data) as? NSDictionary {
                    let comment = IssueComment(dataJson)
                    callback(comment)
                }
        }
    }

}

