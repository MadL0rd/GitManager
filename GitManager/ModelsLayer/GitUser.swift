//
//  GitUser.swift
//  GitManager
//
//  Created by Антон Текутов on 18.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import Foundation

struct GitUser {
    let id: Int64?
    let login: String?
    var email: String
    var blog: String
    var location: String
    let avatarUrl: String?
    var name: String
    var company: String
    var bio: String
    
    init(_ data: NSDictionary?) {
                
        if let dictionary = data{
            id = dictionary["id"] as? Int64
            login = dictionary["login"] as? String
            email = dictionary["email"] as? String ?? ""
            blog = dictionary["blog"] as? String ?? ""
            location = dictionary["location"] as? String ?? ""
            avatarUrl = dictionary["avatar_url"] as? String
            name = dictionary["name"] as? String ?? ""
            company = dictionary["company"] as? String ?? ""
            bio = dictionary["bio"] as? String ?? ""
        }else {
            id = nil
            login = nil
            email = ""
            blog = ""
            location = ""
            avatarUrl = nil
            name = ""
            company = ""
            bio = ""
        }
    }
    
    init() {
        id = nil
        login = nil
        email = ""
        blog = ""
        location = ""
        avatarUrl = nil
        name = ""
        company = ""
        bio = ""
    }
}
