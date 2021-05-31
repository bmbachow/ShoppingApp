//
//  AccountPaymentMethod+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/31/21.
//
//

import Foundation
import CoreData


extension AccountPaymentMethod {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountPaymentMethod> {
        return NSFetchRequest<AccountPaymentMethod>(entityName: "AccountPaymentMethod")
    }

    @NSManaged public var routingNumber: String?
    @NSManaged public var nameOnAccount: String?
    @NSManaged public var accountNumber: String?

}
