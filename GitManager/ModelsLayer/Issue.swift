//
//  Issue.swift
//  GitManager
//
//  Created by Антон Текутов on 06.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import Foundation

struct Issue {
    let id: Int64?
    let number: Int64?
    let url: String?
    let open: Bool
    let title: String
    let body: String
    let user: GitUser?
    let createdAt: Date
    var closedAt: Date
    
    init(_ data: NSDictionary?) {
        if let dictionary = data{
            id = dictionary["id"] as? Int64
            number = dictionary["number"] as? Int64
            url = dictionary["url"] as? String
            open = (dictionary["state"] as? String) == "open"
            title = dictionary["title"] as? String ?? ""
            body = dictionary["body"] as? String ?? ""
            user = GitUser(dictionary["user"] as? NSDictionary)
            
            let dateFormatter = ISO8601DateFormatter()
            if let createdAtString = dictionary["created_at"] as? String, let date = dateFormatter.date(from: createdAtString) {
                createdAt = date
            } else {
                createdAt = Date()
            }
            if open {
                closedAt = Date()
            } else {
                if let createdAtString = dictionary["closed_at"] as? String, let date = dateFormatter.date(from: createdAtString) {
                    closedAt = date
                } else {
                    closedAt = Date()
                }
            }
        }else {
            id = nil
            number = nil
            url = nil
            open = false
            title = ""
            body = ""
            user = nil
            createdAt = Date()
            closedAt = Date()
        }
    }
}
