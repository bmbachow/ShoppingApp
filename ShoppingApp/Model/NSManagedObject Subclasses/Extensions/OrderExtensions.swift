//
//  OrderExtensions.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation

extension Order {
    var productsArray: [Product] {
        self.products?.array as? [Product] ?? []
    }
}
