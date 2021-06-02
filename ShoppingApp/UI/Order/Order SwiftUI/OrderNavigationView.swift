//
//  OrderNavigationView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/28/21.
//

import SwiftUI

protocol SwiftUIOrderViewDelegate: AnyObject {
    func cancel()
    func orderConfirmed(_ order: Order)
}

struct OrderNavigationView: View {
    
    let remoteAPI: RemoteAPI
    @ObservedObject var orderData: OrderData
    
    weak var delegate: SwiftUIOrderViewDelegate?
    
    var body: some View {
        NavigationView {
            ChooseView(remoteAPI: self.remoteAPI, orderData: self.orderData, mode: .address, delegate: self.delegate)
        }
    }
}

