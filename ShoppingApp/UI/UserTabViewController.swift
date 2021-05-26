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
    
    var userTabBarController: UserTabBarController? {
        return self.tabBarController as? UserTabBarController
    }
    
    func presentSignInViewController() {
        let signInViewController = SignInViewController(presentingUserTabViewController: self)
        self.present(signInViewController, animated: true, completion: nil)
    }
    
    func presentSignUpViewController(){
        let registerViewController = RegisterViewController(presentingUserTabViewController: self)
        self.present(registerViewController, animated: true ,completion: nil)
    }
    
    func userChanged() {
    
    }
    
    func cartChanged() {
        
    }
    
    func wishListChanged() {
        
    }
}
