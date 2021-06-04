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
        static let profilePhotoChanged = "profilePhotoChanged"
        static let ordersChanged = "ordersChanged"
    }
    
    
    static func postUserChanged(fromViewController sender: UserTabViewController?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Name.userChanged), object: sender)
    }
    static func postCartChanged(fromViewController sender: UserTabViewController?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Name.cartChanged), object: sender)
    }
    static func postWishListChanged(fromViewController sender: UserTabViewController?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Name.wishListChanged), object: sender)
    }
    static func postGiftCardBalanceChanged(fromViewController sender: UserTabViewController?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Name.giftCardBalanceChanged), object: sender)
    }
    static func postProfilePhotoChanged(fromViewController sender: UserTabViewController?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Name.profilePhotoChanged), object: sender)
    }
    static func postOrdersChanged(fromViewController sender: UserTabViewController?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: Name.ordersChanged), object: sender)
    }
    
    
    static func addUserChangedObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: Name.userChanged), object: nil)
    }
    
    static func addCartChangedObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: Name.cartChanged), object: nil)
    }
    
    static func addWishListChangedObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: Name.wishListChanged), object: nil)
    }
    static func addGiftCardBalanceChangedObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: Name.giftCardBalanceChanged), object: nil)
    }
    static func addProfilePhotoChangedObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: Name.profilePhotoChanged), object: nil)
    }
    static func addOrdersChangedObserver(_ observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: Name.ordersChanged), object: nil)
    }
}
