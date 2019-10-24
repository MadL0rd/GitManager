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
    let name : String?
    let url: String?
    let owner: GitUser?
    var privateAccess: Bool?
    var favorites: Bool
    
    init(_ data: NSDictionary?) {
        
        favorites = false
        
        if let dictionary = data{
            id = dictionary["id"] as? Int64
            name = dictionary["name"] as? String
            url = dictionary["url"] as? String
            owner = GitUser(dictionary["owner"] as? NSDictionary)
            privateAccess = dictionary["private"] as? Bool
        }else {
            id = nil
            name = nil
            url = nil
            owner = nil
            privateAccess = nil
        }
    }
    
}
