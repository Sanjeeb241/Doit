//
//  AppDelegate.swift
//  Doit
//
//  Created by Sanjeeb Samanta on 23/10/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static let shared = AppDelegate()

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        
        print(DataBaseManager.shared.getURL())
        initializeStoryboard()
        
        return true
    }
    
    
    func initializeStoryboard() {
        
        // Main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Create an instance of the UITabBarController
        let tabBarController = UITabBarController()

        // Prepare viewcontroller in storyboard
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeVC")
        let reminderViewController = storyboard.instantiateViewController(withIdentifier: "RemindersVC")
        let categoriesViewController = storyboard.instantiateViewController(withIdentifier: "CategoriesVC")
        
        // Cofigure the tab bar item for each view controller
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        reminderViewController.tabBarItem = UITabBarItem(title: "Reminders", image: UIImage(systemName: "alarm"), selectedImage: UIImage(systemName: "alarm.fill"))
        categoriesViewController.tabBarItem = UITabBarItem(title: "Categories", image: UIImage(systemName: "tray"), selectedImage: UIImage(systemName: "tray.fill"))
        
        // Embed all viewcontrollers into NavigationController
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        let reminderNavigationConroller = UINavigationController(rootViewController: reminderViewController)
        let categoryNavigationController = UINavigationController(rootViewController: categoriesViewController)
        
        // Assign all navigation controllers to TabBarController
        let viewControllers = [homeNavigationController, reminderNavigationConroller, categoryNavigationController]
        tabBarController.viewControllers = viewControllers

        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }


}



