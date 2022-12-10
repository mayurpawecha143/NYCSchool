//
//  AppDelegate.swift
//  NYC Schools
//
//  Created by Mayur Pawecha on 12/7/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        appCoordinator = AppCoordinator(navigationController)
        appCoordinator?.setNYCSchoolListController()
        
        return true
    }
}

