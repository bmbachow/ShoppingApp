//
//  OrderThankYouView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/1/21.
//

import SwiftUI

struct OrderThankYouView: View {
    
    let order: Order
    
    weak var delegate: SwiftUIOrderViewDelegate?
    
    var body: some View {
        ScrollView {
            FormVStack {
                Text("Thank you for your order")
                    .font(.system(size: 20, weight: .bold, design: .default))
                StandardButton(action: { self.delegate?.orderConfirmed(self.order) }, labelText: "Close")
            }
        }
    }
}
