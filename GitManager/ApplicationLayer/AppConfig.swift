//
//  AppConfig.swift
//  GitManager
//
//  Created by Антон Текутов on 11.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

class AppConfig {
    static let GitService = GitHubApiService()
    static let StarredService = StarredRepositoryService(gitService: AppConfig.GitService)
}
