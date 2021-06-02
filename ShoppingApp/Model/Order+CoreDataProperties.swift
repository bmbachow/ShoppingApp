//
//  Order+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/2/21.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var orderedDate: Date?
    @NSManaged public var shippingPrice: Double
    @NSManaged public var subtotal: Double
    @NSManaged public var tax: Double
    @NSManaged public var cartItems: NSOrderedSet?
    @NSManaged public var delivery: Delivery?
    @NSManaged public var paymentMethod: PaymentMethod?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for cartItems
extension Order {

    @objc(insertObject:inCartItemsAtIndex:)
    @NSManaged public func insertIntoCartItems(_ value: CartItem, at idx: Int)

    @objc(removeObjectFromCartItemsAtIndex:)
    @NSManaged public func removeFromCartItems(at idx: Int)

    @objc(insertCartItems:atIndexes:)
    @NSManaged public func insertIntoCartItems(_ values: [CartItem], at indexes: NSIndexSet)

    @objc(removeCartItemsAtIndexes:)
    @NSManaged public func removeFromCartItems(at indexes: NSIndexSet)

    @objc(replaceObjectInCartItemsAtIndex:withObject:)
    @NSManaged public func replaceCartItems(at idx: Int, with value: CartItem)

    @objc(replaceCartItemsAtIndexes:withCartItems:)
    @NSManaged public func replaceCartItems(at indexes: NSIndexSet, with values: [CartItem])

    @objc(addCartItemsObject:)
    @NSManaged public func addToCartItems(_ value: CartItem)

    @objc(removeCartItemsObject:)
    @NSManaged public func removeFromCartItems(_ value: CartItem)

    @objc(addCartItems:)
    @NSManaged public func addToCartItems(_ values: NSOrderedSet)

    @objc(removeCartItems:)
    @NSManaged public func removeFromCartItems(_ values: NSOrderedSet)

}

extension Order : Identifiable {

}
