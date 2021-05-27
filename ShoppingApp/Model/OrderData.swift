//
//  OrderData.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import Foundation
import Combine

class OrderData: ObservableObject {
    @Published var user: User
    @Published var cartItems: [CartItem]
    @Published var paymentMethod: PaymentMethod?
    @Published var address: Address? 
    
    init(user: User, cartItems: [CartItem]) {
        self.user = user
        self.cartItems = cartItems
    }
}
