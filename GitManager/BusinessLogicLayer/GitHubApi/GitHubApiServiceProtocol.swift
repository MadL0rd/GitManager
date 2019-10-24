//
//  GitHubApiServiceProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 24.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

protocol GitHubApiServiceProtocol {
    
    func authentication(login: String, password: String, callBack : @escaping(_ sucess : Bool)-> Void)
    func getRepositories(callBack : @escaping(_ repositories : [Repository])-> Void)
}
