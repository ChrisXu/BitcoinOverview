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
    
    let backend: Backend = isUITesting ? MockBackend() : RestfulBackend()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let presenter = PriceListPresenter(backend: backend)
        let priceListViewController = PriceListViewController(presenter: presenter)
        let rootViewController = UINavigationController(rootViewController: priceListViewController)
        
        window.rootViewController = rootViewController
        window.makeKeyAndVisible()
        
        configureNavigationBar()
        
        return true
    }
    
    // MARK: - Private method
    
    private func configureNavigationBar() {
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = UIColor(hexString: "#38B5CA")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
}

private var isUITesting: Bool {
    let environment = ProcessInfo.processInfo.environment
    
    guard let value = environment["isUITest"] else {
        return false
    }
    return Bool(value) ?? false
}

