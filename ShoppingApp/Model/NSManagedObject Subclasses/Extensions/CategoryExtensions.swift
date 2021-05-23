//
//  CategoryExtensions.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation

extension Category {
    var productsArray: [Product] {
        self.products?.array as? [Product] ?? []
    }
}
