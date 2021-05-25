//
//  UserTabBarController.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation
import UIKit

class UserTabBarController: UITabBarController {
    var user: User? {
        didSet {
            for viewController in self.viewControllers ?? [] {
                guard let userTabViewController = viewController as? UserTabViewController ?? (viewController as? UINavigationController)?.viewControllers[0] as? UserTabViewController else {
                    continue
                }
                userTabViewController.userChanged()
            }
        }
    }
}
