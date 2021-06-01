//
//  OrderExtensions.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation

extension Order {
    
    static let defaultTaxRate: Double = 0.08
    
    static let freeShippingThreshold: Double = 200
    
    var cartItemsArray: [CartItem] {
        self.cartItems?.array as? [CartItem] ?? []
    }
}
