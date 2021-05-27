//
//  UserExtensions.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation

extension User {
    var ordersArray: [Order] {
        self.orders?.array as? [Order] ?? []
    }
    var cartItemsArray: [CartItem] {
        self.cartItems?.array as? [CartItem] ?? []
    }
    var wishListProductsArray: [Product] {
        self.wishListProducts?.array as? [Product] ?? []
    }
    var reviewsArray: [ProductReview] {
        self.reviews?.array as? [ProductReview] ?? []
    }
    var paymentMethodsArray: [PaymentMethod] {
        self.paymentMethods?.array as? [PaymentMethod] ?? []
    }
    var addressesArray: [Address] {
        self.addresses?.array as? [Address] ?? []
    }
    var totalProductsInCart: Int {
        return self.cartItemsArray.reduce(0) { result, cartItem in
            result + Int(cartItem.number)
        }
    }
    var cartSubtotal: Double {
        return self.cartItemsArray.reduce(Double(0), { result, cartItem in
            result + cartItem.itemSubtotal
        })
    }
    
    func setAddressAsDefault(address: Address) {
        
    }
}
