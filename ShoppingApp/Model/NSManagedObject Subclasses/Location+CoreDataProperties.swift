//
//  Location+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/7/21.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var deliveryForCurrentLocation: Delivery?
    @NSManaged public var deliveryForDestinationLocation: Delivery?

}

extension Location : Identifiable {

}
