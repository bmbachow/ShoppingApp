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
    var cartProductsArray: [Product] {
        self.cartProducts?.array as? [Product] ?? []
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
}
