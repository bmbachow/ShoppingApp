//
//  PaymentMethod+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//
//

import Foundation
import CoreData


extension PaymentMethod {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PaymentMethod> {
        return NSFetchRequest<PaymentMethod>(entityName: "PaymentMethod")
    }

    @NSManaged public var user: User?
    @NSManaged public var orders: NSOrderedSet?

}

// MARK: Generated accessors for orders
extension PaymentMethod {

    @objc(insertObject:inOrdersAtIndex:)
    @NSManaged public func insertIntoOrders(_ value: Order, at idx: Int)

    @objc(removeObjectFromOrdersAtIndex:)
    @NSManaged public func removeFromOrders(at idx: Int)

    @objc(insertOrders:atIndexes:)
    @NSManaged public func insertIntoOrders(_ values: [Order], at indexes: NSIndexSet)

    @objc(removeOrdersAtIndexes:)
    @NSManaged public func removeFromOrders(at indexes: NSIndexSet)

    @objc(replaceObjectInOrdersAtIndex:withObject:)
    @NSManaged public func replaceOrders(at idx: Int, with value: Order)

    @objc(replaceOrdersAtIndexes:withOrders:)
    @NSManaged public func replaceOrders(at indexes: NSIndexSet, with values: [Order])

    @objc(addOrdersObject:)
    @NSManaged public func addToOrders(_ value: Order)

    @objc(removeOrdersObject:)
    @NSManaged public func removeFromOrders(_ value: Order)

    @objc(addOrders:)
    @NSManaged public func addToOrders(_ values: NSOrderedSet)

    @objc(removeOrders:)
    @NSManaged public func removeFromOrders(_ values: NSOrderedSet)

}

extension PaymentMethod : Identifiable {

}
