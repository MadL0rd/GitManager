//
//  CollectionItem.swift
//  GitManager
//
//  Created by Антон Текутов on 15.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import Foundation

struct Repository {
    let id: Int64?
    let name : String
    let fullName : String
    let url: String?
    var owner: GitUser?
    var privateAccess: Bool
    var description: String
    var language: String?
    var starred: Bool
    var stargazersCount: Int
    var openIssuesCount: Int
    
    init(_ data: NSDictionary?) {
        
        starred = false
        if let dictionary = data{
            id = dictionary["id"] as? Int64
            name = dictionary["name"] as? String ?? ""
            fullName = dictionary["full_name"] as? String ?? ""
            url = dictionary["url"] as? String
            owner = GitUser(dictionary["owner"] as? NSDictionary)
            privateAccess = dictionary["private"] as? Bool ?? false
            description = dictionary["description"] as? String ?? ""
            language = dictionary["language"] as? String
            stargazersCount = dictionary["stargazers_count"] as? Int ?? 0
            openIssuesCount = dictionary["open_issues"] as? Int ?? 0
        }else {
            id = nil
            name = ""
            fullName = ""
            url = nil
            owner = nil
            privateAccess = false
            description = ""
            language = nil
            openIssuesCount = 0
            stargazersCount = 0
        }
    }
    
}
