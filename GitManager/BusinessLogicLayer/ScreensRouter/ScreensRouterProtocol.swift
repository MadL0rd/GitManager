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
    func showNewScreen(creator: @escaping(_ screensRouter: ScreensRouterProtocol) -> UIViewController, _ withoutNavigationController : Bool)
}

