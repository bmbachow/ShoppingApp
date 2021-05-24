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
        (self.tabBarController as? UserTabBarController)?.user
    }
    
    func presentSignInViewController() {
        let signInViewController = SignInViewController()
        self.present(signInViewController, animated: true, completion: nil)
    }
}
