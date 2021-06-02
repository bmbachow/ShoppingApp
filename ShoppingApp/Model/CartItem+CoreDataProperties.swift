//
//  CartItem+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/2/21.
//
//

import Foundation
import CoreData


extension CartItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItem> {
        return NSFetchRequest<CartItem>(entityName: "CartItem")
    }

    @NSManaged public var number: Int16
    @NSManaged public var order: Order?
    @NSManaged public var product: Product?
    @NSManaged public var user: User?

}

extension CartItem : Identifiable {

}
