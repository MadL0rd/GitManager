//
//  MainTabBarController.swift
//  GitManager
//
//  Created by Антон Текутов on 08.11.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class TabBarCreator {
    
    public static func CreateMainTabBar(mainRouter: ScreensRouterProtocol) -> UITabBarController {
        var tabBarBuff = [UIViewController]()
        
        let iconHome = UITabBarItem()
        iconHome.selectedImage = UIImage(named: "home")
        iconHome.image = UIImage(named: "home")
        var view = ReposListRouter.createModule(screensRouter: mainRouter, content: nil) as UIViewController
        var navController = UINavigationController(rootViewController: view)
        navController.tabBarItem = iconHome
        tabBarBuff.append(navController)
        
        let iconStar = UITabBarItem()
        iconStar.selectedImage = UIImage(named: "star")
        iconStar.image = UIImage(named: "star")
        view = ReposListStarredRouter.createModule(screensRouter: mainRouter, content: nil) as UIViewController
        navController = UINavigationController(rootViewController: view)
        navController.tabBarItem = iconStar
        tabBarBuff.append(navController)
        
        let iconSearch = UITabBarItem()
        iconSearch.selectedImage = UIImage(named: "search")
        iconSearch.image = UIImage(named: "search")
        view = ReposSearchRouter.createModule(screensRouter: mainRouter, content: nil) as UIViewController
        navController = UINavigationController(rootViewController: view)
        navController.tabBarItem = iconSearch
        tabBarBuff.append(navController)
        
        let iconSettings = UITabBarItem()
        iconSettings.selectedImage = UIImage(named: "settings")
        iconSettings.image = UIImage(named: "settings")
        view = SettingsRouter.createModule(screensRouter: mainRouter, content: nil) as UIViewController
        navController = UINavigationController(rootViewController: view)
        navController.tabBarItem = iconSettings
        tabBarBuff.append(navController)
        
        let tabBar = UITabBarController()
        tabBar.setViewControllers(tabBarBuff, animated: true)
        UITabBar.appearance().tintColor = Colors.mainColor
        return tabBar
    }
}
