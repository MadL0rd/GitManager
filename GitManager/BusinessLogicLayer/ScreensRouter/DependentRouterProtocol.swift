//
//  DependentRouterProtocol.swift
//  GitManager
//
//  Created by Антон Текутов on 24.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

protocol DependentRouterProtocol: class {
    
    var mainRouter: ScreensRouterProtocol { get set }
    
    static func createModule(screensRouter: ScreensRouterProtocol) -> UIViewController
}
