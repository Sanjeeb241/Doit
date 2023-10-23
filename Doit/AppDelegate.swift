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
        self.initializeStoryboard()
        return true
    }
    
    
    func initializeStoryboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window = UIWindow(frame: UIScreen.main.bounds)
        let intialViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        let navigationController = UINavigationController(rootViewController: intialViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }


}

