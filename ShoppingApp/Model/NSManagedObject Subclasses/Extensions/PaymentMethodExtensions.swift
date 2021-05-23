//
//  PaymentMethodExtensions.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation

extension PaymentMethod {
    var ordersArray: [Order] {
        self.orders?.array as? [Order] ?? []
    }
}
