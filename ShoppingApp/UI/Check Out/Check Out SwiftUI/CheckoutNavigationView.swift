//
//  CheckoutNavigationView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/28/21.
//

import SwiftUI

protocol SwiftUICheckoutViewDelegate: AnyObject {
    func cancel()
    func orderConfirmed(_ order: Order)
}

struct CheckoutNavigationView: View {
    
    let remoteAPI: RemoteAPI
    @ObservedObject var orderData: OrderData
    
    weak var delegate: SwiftUICheckoutViewDelegate?
    
    var body: some View {
        NavigationView {
            ChooseView(remoteAPI: self.remoteAPI, orderData: self.orderData, mode: .address, delegate: self.delegate)
        }
        .accentColor(Color(UIConstants.appOrangeColor))
        .font(Font(UIConstants.standardFont(size: 17, style: .regular)))
    }
}

