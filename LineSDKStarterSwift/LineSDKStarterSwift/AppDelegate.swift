//
//  AppDelegate.swift
//  LineSDKStarterSwift
//
//  Copyright (c) 2015 Line corp. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        LineAdapter.handleLaunchOptions(launchOptions)
        return true
    }

    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return LineAdapter.handleOpen(url)
    }
}

