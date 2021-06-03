//
//  OrderData.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import Foundation
import Combine

class OrderData: ObservableObject {
    
    static let taxRate: Double = 0.08
    static let freeShippingThreshold: Double = 200
    static let shippingPerProduct: Double = 3.99
    
    @Published var user: User
    @Published var paymentMethod: PaymentMethod?
    @Published var address: Address?
    
    @Published var order: Order?
    @Published var returnItem: CartItem?
    
    var calculatedTax: Double {
        return self.user.cartSubtotal * OrderData.taxRate
    }
    
    var calculatedShipping: Double {
        if self.user.cartSubtotal >= 200 {
            return 0
        }
        return Double(self.user.totalNumberOfProductsInCart) * OrderData.shippingPerProduct
    }
    
    var total: Double {
        return self.user.cartSubtotal + self.calculatedTax + self.calculatedShipping
    }
    
    init(user: User) {
        self.user = user
    }
}
