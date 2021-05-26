//
//  CartItemExtensions.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/26/21.
//

import Foundation

extension CartItem {
    var itemSubtotal: Double {
        guard let product = self.product else {
            return 0
        }
        return product.price * Double(self.number)
    }
}
