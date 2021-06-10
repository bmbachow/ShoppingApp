//
//  Address+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/10/21.
//
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var city: String?
    @NSManaged public var fullName: String?
    @NSManaged public var isDefault: Bool
    @NSManaged public var state: String?
    @NSManaged public var streetAddress: String?
    @NSManaged public var streetAddress2: String?
    @NSManaged public var zipCode: String?
    @NSManaged public var deliveries: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for deliveries
extension Address {

    @objc(addDeliveriesObject:)
    @NSManaged public func addToDeliveries(_ value: Delivery)

    @objc(removeDeliveriesObject:)
    @NSManaged public func removeFromDeliveries(_ value: Delivery)

    @objc(addDeliveries:)
    @NSManaged public func addToDeliveries(_ values: NSSet)

    @objc(removeDeliveries:)
    @NSManaged public func removeFromDeliveries(_ values: NSSet)

}

extension Address : Identifiable {

}
