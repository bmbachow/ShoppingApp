//
//  UserExtensions.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation
import UIKit

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
    var totalNumberOfProductsInCart: Int {
        return self.cartItemsArray.reduce(0) { result, cartItem in
            result + Int(cartItem.number)
        }
    }
    var cartSubtotal: Double {
        return self.cartItemsArray.reduce(Double(0), { result, cartItem in
            result + cartItem.itemSubtotal
        })
    }
    
    var fullName: String {
        return (self.firstName ?? "firstName?") + " " + (self.lastName ?? "lastName?")
    }
    
    var defaultAddress: Address? {
        return self.addressesArray.first(where: { $0.isDefault })
    }
    
    var defaultPaymentMethod: PaymentMethod? {
        return self.paymentMethodsArray.first(where: { $0.isDefault })
    }
    
    
    var image: UIImage? {
        guard let data = self.imageData else { return nil }
        return UIImage(data: data)
    }
    
    func setImageDataFromImage(_ image: UIImage?) {
        guard let imageData = image?.pngData() else { return }
        self.imageData = imageData
    }
}
