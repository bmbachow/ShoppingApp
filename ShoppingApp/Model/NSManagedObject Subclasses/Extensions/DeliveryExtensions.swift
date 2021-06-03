//
//  DeliveryExtensions.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/23/21.
//

import Foundation

enum DeliveryStatus: CustomStringConvertible {
    case preparingShipment
    case inTransit
    case delivered
    
    var description: String {
        switch self {
        case .preparingShipment:
            return "Preparing Shipment"
        case .inTransit:
            return "In Transit"
        case .delivered:
            return "Delivered"
        }
    }
}

extension Delivery {
    
    var status: DeliveryStatus {
        if self.shippedDate == nil {
            return .preparingShipment
        } else if self.deliveredDate == nil {
            return .inTransit
        } else {
            return .delivered
        }
    }
}
