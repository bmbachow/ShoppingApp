//
//  UserTabViewController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation
import UIKit

class UserTabViewController: BaseViewController {
    var user: User? {
        get {
            (self.tabBarController as? UserTabBarController)?.user
        } set {
            (self.tabBarController as? UserTabBarController)?.user = newValue
        }
        
    }
    
    func presentSignInViewController() {
        let signInViewController = SignInViewController()
        self.present(signInViewController, animated: true, completion: nil)
    }
}
