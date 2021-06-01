//
//  OrderConfirmationView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/1/21.
//

import SwiftUI

struct OrderConfirmationView: View {
    
    let remoteAPI: RemoteAPI
    @ObservedObject var orderData: OrderData
    
    var body: some View {
        Text("Order Confirmation")
    }
}
