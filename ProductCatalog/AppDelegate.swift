//
//  AppDelegate.swift
//  ProductCatalog
//
//  Created by Lucas Domene Firmo on 11/8/16.
//  Copyright © 2016 Domene. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let rootViewController = window!.rootViewController as! UINavigationController
        let productsViewController = rootViewController.topViewController as! ProductsViewController
        productsViewController.productStore = ProductStore()
        
        // NavigationBar Appearance
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 1, green: 222.0/255.0, blue: 20.0/255.0, alpha: 1.0)
        
        if let barFont = UIFont(name: "Avenir-Light", size: 24.0) {
            UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: barFont]
        }
        
        return true
    }

}

