//
//  CashOnDeliveryPaymentMethod+CoreDataProperties.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/10/21.
//
//

import Foundation
import CoreData


extension CashOnDeliveryPaymentMethod {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CashOnDeliveryPaymentMethod> {
        return NSFetchRequest<CashOnDeliveryPaymentMethod>(entityName: "CashOnDeliveryPaymentMethod")
    }


}
