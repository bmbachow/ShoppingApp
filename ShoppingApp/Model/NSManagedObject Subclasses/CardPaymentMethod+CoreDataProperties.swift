//
//  CardPaymentMethod+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/31/21.
//
//

import Foundation
import CoreData


extension CardPaymentMethod {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CardPaymentMethod> {
        return NSFetchRequest<CardPaymentMethod>(entityName: "CardPaymentMethod")
    }

    @NSManaged public var nameOnCard: String?
    @NSManaged public var cardNumber: String?
    @NSManaged public var expirationMonth: Int16
    @NSManaged public var expirationYear: Int16

}
