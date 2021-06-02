//
//  Delivery+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/2/21.
//
//

import Foundation
import CoreData


extension Delivery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Delivery> {
        return NSFetchRequest<Delivery>(entityName: "Delivery")
    }

    @NSManaged public var deliveredDate: Date?
    @NSManaged public var expectedDeliveryDate: Date?
    @NSManaged public var shippedDate: Date?
    @NSManaged public var address: Address?
    @NSManaged public var currentLocation: Location?
    @NSManaged public var destinationLocation: Location?
    @NSManaged public var order: Order?

}

extension Delivery : Identifiable {

}
