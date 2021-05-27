//
//  SampleData.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import Foundation
import UIKit
import CoreData

class SampleData {
    
    static var container = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    static var cartItems: [CartItem] {
        var cartItems = [CartItem]()
        for i in 0..<5 {
            let item = CartItem(context: container.viewContext)
            let product = Product(context: container.viewContext)
            product.name = "item \(i)"
            product.setImageDataFromImage(UIImage(systemName: "questionmark.circle")!)
            product.price = Double.random(in: 1...10)
            item.product = product
            item.number = Int16.random(in: 1...3)
            cartItems += [item]
        }
        return cartItems
    }
}
