//
//  AppDelegate.swift
//  BitcoinOverview
//
//  Created by Chris Xu on 2019/4/13.
//  Copyright © 2019 CXCreation. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let window = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let priceListViewController = PriceListViewController()
        let rootViewController = UINavigationController(rootViewController: priceListViewController)
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        configureNavigationBar()
        
        return true
    }
    
    // MARK: - Private method
    
    private func configureNavigationBar() {
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().barTintColor = UIColor(hexString: "#38B5CA")
    }
}

