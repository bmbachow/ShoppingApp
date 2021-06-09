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
        FormVStack {
            StandardText("Thank you for your order", size: 20, style: .bold)
            StandardText("You will recieve a confirmation email shortly.")
            StandardButton1(action: { self.delegate?.continueShopping(self.order) }, labelText: "Continue shopping")
            /*
            StandardButton2(action: { self.delegate?.orderConfirmed(self.order) }, labelText: "Close")
 */
        }
    }
}
