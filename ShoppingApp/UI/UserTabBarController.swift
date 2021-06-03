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
            for viewController in self.userTabViewControllers {
                viewController.userChanged()
            }
            self.cartChanged(fromViewController: nil)
        }
    }
    
    init(shoppingViewController: ShoppingViewController, userHomeViewController: UserHomeSignedInViewController, cartViewController: CartViewController, settingsViewController: SettingsViewController) {
        self.shoppingViewController = shoppingViewController
        self.userHomeViewController = userHomeViewController
        self.cartViewController = cartViewController
        self.settingsViewController = settingsViewController
        
        self.shoppingNavigationController = UINavigationController(rootViewController: self.shoppingViewController)
        self.shoppingNavigationController.tabBarItem = UITabBarItem(title: "Shop", image: UIImage(systemName: "house"), selectedImage: nil)
        
        self.userHomeNavigationController = UINavigationController(rootViewController: self.userHomeViewController)
        self.userHomeNavigationController.tabBarItem = UITabBarItem(title: "User", image: UIImage(systemName: "person"), selectedImage: nil)
        
        self.cartNavigationController = UINavigationController(rootViewController: self.cartViewController)
        self.cartNavigationController.tabBarItem = UITabBarItem(title: "Cart", image: UIImage(systemName: "cart"), selectedImage: nil)
        self.cartNavigationController.tabBarItem.badgeColor = .systemGreen
        
        self.settingsNavigationController = UINavigationController(rootViewController: self.settingsViewController)
        self.settingsNavigationController.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "line.horizontal.3"), selectedImage: nil)
        super.init(nibName: nil, bundle: nil)
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
    }
    
    func cartChanged(fromViewController sender: UserTabViewController?) {
        for viewController in self.userTabViewControllers {
            guard viewController != sender else { continue }
            viewController.cartChanged()
        }
        self.refreshCartBadge()
    }
    
    func wishListChanged(fromViewController sender: UserTabViewController?) {
        for viewController in self.userTabViewControllers {
            guard viewController != sender else { continue }
            viewController.wishListChanged()
        }
    }
    
    private func refreshCartBadge() {
        if let cartItemsCount = user?.totalNumberOfProductsInCart {
            self.cartNavigationController.tabBarItem.badgeValue = String(cartItemsCount)
        } else {
            self.cartNavigationController.tabBarItem.badgeValue = nil
        }
    }
}
