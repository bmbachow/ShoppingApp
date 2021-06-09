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
    @Published var amountPaidWithGiftCardBalance: Double
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
    
    var totalBeforeGiftCard: Double {
        return self.user.cartSubtotal + self.calculatedTax + self.calculatedShipping
    }
    
    var totalAfterGiftCard: Double {
        let total = self.user.cartSubtotal + self.calculatedTax + self.calculatedShipping - self.amountPaidWithGiftCardBalance
        return total > 0 ? total : 0
    }
    
    init(user: User) {
        self.user = user
        self.amountPaidWithGiftCardBalance = user.giftCardBalance
    }
}
