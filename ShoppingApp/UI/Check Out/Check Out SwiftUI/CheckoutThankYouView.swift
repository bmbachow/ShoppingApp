//
//  CheckoutThankYouView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/1/21.
//

import SwiftUI

struct CheckoutThankYouView: View {
    
    let order: Order
    
    weak var delegate: SwiftUICheckoutViewDelegate?
    
    var body: some View {
        ScrollView {
            FormVStack {
                StandardText("Thank you for your order", size: 20, style: .bold)
                StandardButton(action: { self.delegate?.orderConfirmed(self.order) }, labelText: "Close")
            }
        }
    }
}
