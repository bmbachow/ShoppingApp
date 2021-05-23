//
//  Delivery+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//
//

import Foundation
import CoreData


extension Delivery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Delivery> {
        return NSFetchRequest<Delivery>(entityName: "Delivery")
    }

    @NSManaged public var deliveredDate: Date?
    @NSManaged public var shippedDate: Date?
    @NSManaged public var expectedDeliveryDate: Date?
    @NSManaged public var order: Order?
    @NSManaged public var destinationLocation: Location?
    @NSManaged public var currentLocation: Location?

}

extension Delivery : Identifiable {

}
