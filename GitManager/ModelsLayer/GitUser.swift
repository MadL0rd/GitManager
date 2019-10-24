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
    let avatarUrl: String?
    
    init(_ data: NSDictionary?) {
                
        if let dictionary = data{
            id = dictionary["id"] as? Int64
            login = dictionary["login"] as? String
            avatarUrl = dictionary["avatar_url"] as? String
        }else {
            id = nil
            login = nil
            avatarUrl = nil
        }
    }
}
