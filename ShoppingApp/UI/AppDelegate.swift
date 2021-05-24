//
//  AppDelegate.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/21/21.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var remoteAPI: RemoteAPI?

    var tabBarController: UserTabBarController?
    
    var shoppingNavigationController: UINavigationController?
    var shoppingViewController: ShoppingViewController?
    
    var userHomeNavigationController: UINavigationController?
    var userHomeViewController: UserHomeViewController?
    
    var cartNavigationController: UINavigationController?
    var cartViewController: CartViewController?
    
    var settingsNavigationController: UINavigationController?
    var settingsViewController: SettingsViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.remoteAPI = CoreDataHelper(container: self.persistentContainer)
        
        self.tabBarController = UserTabBarController()
        self.window!.rootViewController = self.tabBarController!
        
        self.shoppingViewController = ShoppingViewController()
        self.shoppingViewController!.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(systemName: "house"), selectedImage: nil)
        self.shoppingNavigationController = UINavigationController(rootViewController: self.shoppingViewController!)
        self.shoppingNavigationController!.setNavigationBarHidden(true, animated: false)
        
        self.userHomeViewController = UserHomeViewController()
        self.userHomeViewController!.tabBarItem = UITabBarItem(title: "User", image: UIImage(systemName: "person"), selectedImage: nil)
        self.userHomeNavigationController = UINavigationController(rootViewController: self.userHomeViewController!)
        self.userHomeNavigationController!.setNavigationBarHidden(true, animated: false)
        
        self.cartViewController = CartViewController()
        self.cartViewController!.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart"), selectedImage: nil)
        self.cartNavigationController = UINavigationController(rootViewController: self.cartViewController!)
        self.cartNavigationController!.setNavigationBarHidden(true, animated: false)
        
        self.settingsViewController = SettingsViewController()
        self.settingsViewController!.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "line.horizontal.3"), selectedImage: nil)
        self.settingsNavigationController = UINavigationController(rootViewController: self.settingsViewController!)
        self.settingsNavigationController!.setNavigationBarHidden(true, animated: false)
        
        self.tabBarController!.viewControllers = [self.shoppingNavigationController!, self.userHomeNavigationController!, self.cartNavigationController!, self.settingsNavigationController!]
        
        self.window!.rootViewController = self.tabBarController!
        self.window!.makeKeyAndVisible()
        
        // Override point for customization after application launch.
        return true
    }

    
    

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "ShoppingApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

