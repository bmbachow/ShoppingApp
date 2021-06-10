//
//  AnonymousUser+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/10/21.
//
//

import Foundation
import CoreData


extension AnonymousUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AnonymousUser> {
        return NSFetchRequest<AnonymousUser>(entityName: "AnonymousUser")
    }

    @NSManaged public var uuid: UUID?

}
