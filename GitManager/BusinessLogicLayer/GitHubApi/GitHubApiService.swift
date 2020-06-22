//
//  GitHubApiService.swift
//  GitManager
//
//  Created by Антон Текутов on 18.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import Alamofire

class GitHubApiService: GitHubApiServiceProtocol {
    
    private let keyStorage: KeychainServiceProtocol = KeychainService()
    private let parser : FileParserProtocol = GitHubFileParser()
    private let apiUrl = "https://api.github.com/"
    static private var headers : HTTPHeaders = [:]
    private var searchRequest : Request?
    private var searchRequestCount = 0
    
    private let clientID: String = "0a73c3a488f79a02b4b4"
    private let clientSecret: String = "fc0496b8b87a616926bc3923de1f53e9656d9905"
    
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
        
        var urlRequest = apiUrl + "search/repositories?q=\(name)+language:\(language)&page=\(pageNumber)&per_page=\(itemsPerPage)&sort=stars&order=desc"
        urlRequest = urlRequest.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? urlRequest
        searchRequest = Alamofire.request(urlRequest,
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
    
    func createTokenAndAuthenticate(callback: @escaping(_ success : Bool) -> Void) {
        
        let clientID: String = "0a73c3a488f79a02b4b4"
        let clientSecret: String = "fc0496b8b87a616926bc3923de1f53e9656d9905"
        let authorizeUrl = URL(string: "https://github.com/login/oauth/authorize")!
        let accessTokenUrl = "https://github.com/login/oauth/access_token"
        let callbackURL = "GitManager://callback/"
        
        // Добавляем к строке запроса необходимые параметры
        let clientIDQuery             = URLQueryItem(name: "client_id", value: clientID)
        let redirectURLQuery          = URLQueryItem(name: "redirect_uri", value: callbackURL)
        let scopeQuery: URLQueryItem  = URLQueryItem(name: "scope", value: "user repo")
        
        
        var components          = URLComponents(url: authorizeUrl, resolvingAgainstBaseURL: true)
        components?.queryItems  = [clientIDQuery, redirectURLQuery, scopeQuery]
        
        AppDelegate.urlHandlers.append({ url in
            
            var accessCodeOptional: String?
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
                for queryItem in components.queryItems! {
                    if queryItem.name == "code" {
                        accessCodeOptional = queryItem.value
                    }
                }
            }
            
            guard let accessCode = accessCodeOptional 
                else { return }
            
            // Запускаем процесс обмена данными
            let url = accessTokenUrl
            let params = [
                "client_id": clientID,
                "client_secret": clientSecret,
                "code": accessCode,
                "redirect_uri": callbackURL
                ] as Parameters?
            
            let headers: HTTPHeaders = [
                "Accept": "application/json"
            ]
            
            
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
                if	let responseJSON = response.result.value as? [String:Any],
                	let token = responseJSON["access_token"] as? String {
                    self.keyStorage.setUserToken(token)
                    self.authenticate(callback: callback)
                }
            }
        })
        
        UIApplication.shared.open(components!.url!, options: [:], completionHandler: nil)
    }
    
    func authenticate(callback : @escaping(_ success : Bool)-> Void) {
        guard let token = keyStorage.getUserToken() 
            else { 
                callback(false)
                return
        }
        
        GitHubApiService.headers = ["Authorization": "token \(token)"]
        Alamofire.request(apiUrl + "user",
                          headers: GitHubApiService.headers)
            .responseJSON{ response in
                if	let data = response.data, 
                    let dataJson = self._parseJsonResponse(data: data) as? NSDictionary,
                    let _ = dataJson["login"] as? String {
                    callback(true)
                } else { 
                    callback(false)
                }
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
        let escapedPath = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? path
        let urlRequest = "https://github.com/\(repository.fullName)/blob\(escapedPath)"
        Alamofire.request(urlRequest,
                          headers: GitHubApiService.headers)
            .responseJSON{ response in
                if let data = response.data {
                    guard let html = String(data: data, encoding: String.Encoding.utf8) else { return }
                    callback(self.parser.parsePage(htmlSource: html))
                }
        }
    }
    
    func getFileContent(dir: Directory, callback: @escaping(_ content : String?) -> Void ) {
        guard dir.type == .file 
            else { return }
        Alamofire.request(dir.url,
                          headers: GitHubApiService.headers)
            .responseJSON{ response in
                if 	let data = response.data,
                    let dataJson = self._parseJsonResponse(data: data) as? NSDictionary,
                    let contentBase64 =  dataJson["content"] as? String {
                    let lines = contentBase64.split(separator: "\n")
                    var content  = ""
                    for line in lines {
                        content += line
                    }
                    if let contentResult = content.fromBase64() {
                        callback(contentResult)
                        return
                    }
                }
                callback(nil)
                return
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

