//
//  Directory.swift
//  GitManager
//
//  Created by Антон Текутов on 03.05.2020.
//  Copyright © 2020 Антон Текутов. All rights reserved.
//

import Foundation

enum DirectoryType {
    case folder
    case file
    case branch
}

struct Directory: Equatable {
    
    let type: DirectoryType
    let name: String
    let url: String
}
