//
//  OrderExtensions.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation

extension Order {
    
    var cartItemsArray: [CartItem] {
        self.cartItems?.array as? [CartItem] ?? []
    }
    
    var deliveryStatus: DeliveryStatus {
        return self.delivery?.status ?? .preparingShipment
    }
    
    var total: Double {
        return self.subtotal + self.tax + self.shippingPrice
    }
}
