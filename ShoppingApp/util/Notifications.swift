//
//  Notifications.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/3/21.
//

import Foundation

class Notifications {
    
    struct Name {
        static let userChanged = "userChanged"
        static let cartChanged = "cartChanged"
        static let wishListChanged = "wishListChanged"
        static let giftCardBalanceChanged = "giftCardBalanceChanged"
    }
    
    static func postUserChanged(fromViewController sender: UserTabViewController) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Name.userChanged), object: sender)
    }
    static func postCartChanged(fromViewController sender: UserTabViewController) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Name.cartChanged), object: sender)
    }
    static func postWishListChanged(fromViewController sender: UserTabViewController) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Name.wishListChanged), object: sender)
    }
    static func postGiftCardBalanceChanged(fromViewController sender: UserTabViewController) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Name.giftCardBalanceChanged), object: sender)
    }
}
