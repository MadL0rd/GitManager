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
    
    required init(mainWindow: UIWindow) {
        window = mainWindow
        window.makeKeyAndVisible()
    }
    
    func showNewScreen<T>(_ creator: T.Type) where T : DependentRouterProtocol {
        let view = creator.createModule(screensRouter: self)
        window.rootViewController = view
    }

    func pushNewScreenToNavigationController<T>(_ creator: T.Type) where T : DependentRouterProtocol {
        let view = creator.createModule(screensRouter: self)
        if navigationController == nil {
            navigationController = UINavigationController(rootViewController: view)
        }else{
            navigationController?.pushViewController(view, animated: true)
        }
        window.rootViewController = navigationController
    }
}
