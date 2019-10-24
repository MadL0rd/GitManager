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
    
    func showNewScreen(creator: ((ScreensRouterProtocol) -> UIViewController), _ withoutNavigationController: Bool = false) {
        let view = creator(self)
        if withoutNavigationController {
            window.rootViewController = view
        }else{
            if navigationController == nil {
                navigationController = UINavigationController(rootViewController: view)
                window.rootViewController = navigationController
            }else{
                navigationController?.pushViewController(view, animated: true)
            }
        }
    }
}
