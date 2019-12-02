//
//  AppDelegate.swift
//  GitManager
//
//  Created by Антон Текутов on 15.10.2019.
//  Copyright © 2019 Антон Текутов. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let screenRouter = ScreensRouter(mainWindow: window)
        screenRouter.showNewScreen(AuthenticationRouter.self)
        
        return true
    }
}
