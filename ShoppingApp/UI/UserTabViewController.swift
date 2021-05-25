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
            print("set user")
            (self.tabBarController as? UserTabBarController)?.user = newValue
        }
        
    }
    
    func presentSignInViewController() {
        let signInViewController = SignInViewController(presentingUserTabViewController: self)
        self.present(signInViewController, animated: true, completion: nil)
    }
    
    func presentSignUpViewController(){
        let registerViewController = RegisterViewController(presentingUserTabViewController: self)
        self.present(registerViewController, animated: true ,completion: nil)
    }
}
