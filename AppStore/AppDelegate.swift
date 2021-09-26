//
//  AppDelegate.swift
//  AppStore
//
//  Created by user on 24.09.2021.
//  Copyright © 2021 ulkoart. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = BaseTabBarController()
        window?.makeKeyAndVisible()
                                    
        return true
    }
}

