//
//  AppDelegate.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 23/10/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let intialViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        let navigationController = UINavigationController(rootViewController: intialViewController)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        return true
    }
    
    
    func initializeStoryboard() {

    }


}

