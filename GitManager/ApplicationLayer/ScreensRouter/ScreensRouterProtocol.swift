//
//  ScreensRouterProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 24.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

protocol ScreensRouterProtocol: class {
    
    var window: UIWindow { get }
    
    init(mainWindow: UIWindow)
    func showNewScreen<T: DependentRouterProtocol>(_ creator: T.Type)
    func pushNewScreenToCurrentNavigationController<T: DependentRouterProtocol>(_ creator: T.Type, content : AnyObject?)
    func pushNewScreenToNewNavigationController<T: DependentRouterProtocol>(_ creator: T.Type, content : AnyObject?)
    func showTabBar(createTabBar : @escaping(_ mainRouter: ScreensRouterProtocol)-> UITabBarController)
}

extension ScreensRouterProtocol{
    func pushNewScreenToCurrentNavigationController<T: DependentRouterProtocol>(_ creator: T.Type){
        pushNewScreenToCurrentNavigationController(creator.self, content: nil)
    }
    func pushNewScreenToNewNavigationController<T: DependentRouterProtocol>(_ creator: T.Type){
        pushNewScreenToNewNavigationController(creator.self, content: nil)
    }
}
