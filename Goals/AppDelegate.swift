//
//  AppDelegate.swift
//  Goals
//
//  Created by Guilherme Souza on 26/12/17.
//  Copyright © 2017 Guilherme Souza. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: MyGoalsModule.build())
        window?.makeKeyAndVisible()

        return true
    }

    private func setupAppearance() {
        UINavigationBar.appearance().barTintColor = Color.primaryGreen
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().prefersLargeTitles = true

        UITabBar.appearance().tintColor = Color.primaryGreen
    }
}
