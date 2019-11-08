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
        view = ReposListRouter.createModule(screensRouter: mainRouter, content: nil) as UIViewController
        navController = UINavigationController(rootViewController: view)
        navController.tabBarItem = iconSearch
        tabBarBuff.append(navController)
        
        let tabBar = UITabBarController()
        tabBar.setViewControllers(tabBarBuff, animated: true)
        return tabBar
    }
}