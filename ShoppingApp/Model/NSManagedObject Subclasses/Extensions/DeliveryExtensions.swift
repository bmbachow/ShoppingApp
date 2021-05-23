//
//  DeliveryExtensions.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation

extension Delivery {
    var isDelivered: Bool {
        self.deliveredDate != nil
    }
    var isInTransit: Bool {
        self.shippedDate != nil
            && self.deliveredDate == nil
    }
    var isPreparingShipment: Bool {
        self.shippedDate == nil
    }
}
