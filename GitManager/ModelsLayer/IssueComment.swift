//
//  IssueComment.swift
//  GitManager
//
//  Created by Антон Текутов on 13.12.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//
import Foundation

struct IssueComment {
    let id: Int64?
    let body: String
    let user: GitUser?
    let owner: Bool
    let createdAt: Date
    let updatedAt: Date
    
    init(_ data: NSDictionary?) {
        if let dictionary = data{
            id = dictionary["id"] as? Int64
            body = dictionary["body"] as? String ?? ""
            user = GitUser(dictionary["user"] as? NSDictionary)
            owner = (dictionary["author_association"] as? String) == "OWNER"
            
            let dateFormatter = ISO8601DateFormatter()
            if let createdAtString = dictionary["created_at"] as? String, let date = dateFormatter.date(from: createdAtString) {
                createdAt = date
            } else {
                createdAt = Date()
            }
            if let updatedAtString = dictionary["updated_at"] as? String, let date = dateFormatter.date(from: updatedAtString) {
                updatedAt = date
            } else {
                updatedAt = Date()
            }
        }else {
            id = nil
            body = ""
            user = nil
            owner = false
            createdAt = Date()
            updatedAt = Date()
        }
    }
}

