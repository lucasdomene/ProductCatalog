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
        
        return true
    }

}

