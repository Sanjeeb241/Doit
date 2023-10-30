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
        print(DataBaseManager.shared.getURL())
        initializeStoryboard()
        return true
    }
    
    
    func initializeStoryboard() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Create an instance of the UITabBarController
        let tabBarController = UITabBarController()

        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        let categoriesViewController = storyboard.instantiateViewController(withIdentifier: "CategoriesVC")
        
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        categoriesViewController.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "tray"), selectedImage: UIImage(systemName: "tray.fill"))
        
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let secondNavigationController = UINavigationController(rootViewController: categoriesViewController)
        
        let viewControllers = [homeNavigationController, secondNavigationController]
        tabBarController.viewControllers = viewControllers

        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }


}



