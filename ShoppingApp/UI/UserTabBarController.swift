//
//  UserTabBarController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation
import UIKit

class UserTabBarController: UITabBarController {
    
    var appDelegate: AppDelegate { UIApplication.shared.delegate as! AppDelegate }
    
    var remoteAPI: RemoteAPI { self.appDelegate.remoteAPI! }
    
    let shoppingNavigationController: UINavigationController
    let userHomeNavigationController: UINavigationController
    let cartNavigationController: UINavigationController
    let settingsNavigationController: UINavigationController
    let shoppingViewController: ShoppingViewController
    let userHomeViewController: UserHomeSignedInViewController
    let cartViewController: CartViewController
    let settingsViewController: SettingsViewController
    
    var navigationControllers: [UINavigationController] {
        return [self.shoppingNavigationController, self.userHomeNavigationController, self.cartNavigationController, self.settingsNavigationController]
    }
    
    var userTabViewControllers: [UserTabViewController] {
        return [self.shoppingViewController, self.userHomeViewController, self.cartViewController, self.settingsViewController]
    }
    
    var user: User? {
        didSet {
            Notifications.postUserChanged(fromViewController: nil)
            self.refreshCartBadge()
        }
    }
    
    init(shoppingViewController: ShoppingViewController, userHomeViewController: UserHomeSignedInViewController, cartViewController: CartViewController, settingsViewController: SettingsViewController) {
        self.shoppingViewController = shoppingViewController
        self.userHomeViewController = userHomeViewController
        self.cartViewController = cartViewController
        self.settingsViewController = settingsViewController
     
        self.shoppingNavigationController = UINavigationController(rootViewController: self.shoppingViewController)
        self.shoppingNavigationController.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(systemName: "bag"), selectedImage: UIImage(systemName: "bag.fill"))
        
        self.userHomeNavigationController = UINavigationController(rootViewController: self.userHomeViewController)
        self.userHomeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
        
        self.cartNavigationController = UINavigationController(rootViewController: self.cartViewController)
        self.cartNavigationController.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart"), selectedImage: UIImage(systemName: "cart.fill"))
        self.cartNavigationController.tabBarItem.badgeColor = UIConstants.appOrangeColor
            
        self.settingsNavigationController = UINavigationController(rootViewController: self.settingsViewController)
        self.settingsNavigationController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "line.horizontal.3"), selectedImage: nil)
        super.init(nibName: nil, bundle: nil)
        self.tabBar.tintColor = UIConstants.secondaryButtonColor
        
        for navigationController in self.navigationControllers {
            navigationController.setNavigationBarHidden(true, animated: false)
        }
        self.viewControllers = self.navigationControllers
      
        if let uuid = UIDevice.current.identifierForVendor {
            self.remoteAPI.getAnonymousUserOrCreateIfNotExists(
                uuid: uuid,
                success: { anonymousUser in
                    self.user = anonymousUser
                }, failure: { error in
                    print(error.localizedDescription)
                })
        }
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Notifications.addCartChangedObserver(self, selector: #selector(self.cartChanged(_:)))
    }
    
    @objc func cartChanged(_ notification: Notification) {
        self.refreshCartBadge()
    }
    
    private func refreshCartBadge() {
        if let cartItemsCount = user?.totalNumberOfProductsInCart {
            self.cartNavigationController.tabBarItem.badgeValue = String(cartItemsCount)
        } else {
            self.cartNavigationController.tabBarItem.badgeValue = nil
        }
    }
}
