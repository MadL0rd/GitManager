//
//  ScreensRouter.swift
//  GitManager
//
//  Created by Антон Текутов on 24.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

class ScreensRouter: ScreensRouterProtocol {
    
    let window: UIWindow
    var navigationController : UINavigationController?
    var tabBarController : UITabBarController?
    
    required init(mainWindow: UIWindow) {
        window = mainWindow
        window.makeKeyAndVisible()
    }
    
    func showNewScreen<T>(_ creator: T.Type) where T : DependentRouterProtocol {
        navigationController = nil
        let view = creator.createModule(screensRouter: self)
        window.rootViewController = view
    }
    
    func pushNewScreenToCurrentNavigationController<T>(_ creator: T.Type, content: AnyObject?) where T : DependentRouterProtocol {
        let view = creator.createModule(screensRouter: self, content: content)
        if let navigation = tabBarController?.selectedViewController as? UINavigationController{
            navigation.pushViewController(view, animated: true)
        }else{
            if navigationController == nil {
                navigationController = UINavigationController(rootViewController: view)
            }else{
                navigationController?.pushViewController(view, animated: true)
            }
            window.rootViewController = navigationController
        }
    }
    
    func pushNewScreenToNewNavigationController<T>(_ creator: T.Type, content: AnyObject?) where T : DependentRouterProtocol {
        let view = creator.createModule(screensRouter: self, content: content)
        navigationController = UINavigationController(rootViewController: view)
        window.rootViewController = navigationController
    }
    
    func showTabBar(createTabBar: @escaping (ScreensRouterProtocol) -> UITabBarController) {
        tabBarController = createTabBar(self)
        window.rootViewController = tabBarController
    }
    
}
