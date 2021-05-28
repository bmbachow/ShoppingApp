//
//  OrderNavigationView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/28/21.
//

import SwiftUI

struct OrderNavigationView: View {
    
    let remoteAPI: RemoteAPI
    @ObservedObject var orderData: OrderData
    let cancelAction: () -> Void
    
    
    var body: some View {
        NavigationView {
            ChooseView(remoteAPI: self.remoteAPI, orderData: self.orderData, cancelAction: self.cancelAction, mode: .address)
        }
    }
}

