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
    
    var shoppingViewController: ShoppingViewController?
    
    var userHomeViewController: UserHomeSignedInViewController?
    
    var cartViewController: CartViewController?
    
    var settingsViewController: SettingsViewController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        self.remoteAPI = CoreDataHelper(container: self.persistentContainer)
        
        self.shoppingViewController = ShoppingViewController()
        
        self.userHomeViewController = UserHomeSignedInViewController()
        
        self.cartViewController = CartViewController()
        
        self.settingsViewController = SettingsViewController()
        
        self.setupUIAppearance()
        
        self.tabBarController = UserTabBarController(shoppingViewController: self.shoppingViewController!, userHomeViewController: self.userHomeViewController!, cartViewController: self.cartViewController!, settingsViewController: self.settingsViewController!)
        
        self.window!.rootViewController = self.tabBarController!
        
        self.window!.rootViewController = self.tabBarController!
        self.window!.makeKeyAndVisible()
    
        
        
   
 
        return true
    }

    func setupUIAppearance() {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIConstants.standardFont(size: 19, style: .regular)], for: .normal)
        UIBarButtonItem.appearance().tintColor = UIConstants.appOrangeColor
 
        
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIConstants.standardFont(size: 19, style: .semiBold)]
 
        /*
        UINavigationBar.appearance().backgroundColor = .white
        UINavigationBar.appearance().isTranslucent = false
 */
 
        UINavigationBar.appearance().setBackgroundImage(UIImage(color: .white)!, for: UIBarMetrics.default)
        
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().isOpaque = true
        
        
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        
        UITabBar.appearance().isTranslucent = true
        //UITabBar.appearance().barTintColor = UIConstants.accentColorApp
        
        UITextField.appearance().font = UIConstants.standardFont(size: 18, style: .regular)
    
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIConstants.standardFont(size: 10, style: .regular)], for: .normal)
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

