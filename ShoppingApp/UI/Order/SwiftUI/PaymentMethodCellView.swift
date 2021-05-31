//
//  PaymentMethodCellView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/31/21.
//

import Foundation
import SwiftUI

struct PaymentMethodCellView: View {
    
    let paymentMethod: PaymentMethod
    var isSelected: Bool
    let navigationAction: () -> Void
    let selectedAction: () -> Void
    
    var numberLine: String {
        if let card = self.paymentMethod as? CardPaymentMethod {
            let number = card.cardNumber ?? "number?"
            return "Card ****" + number.suffix(4)
        } else if let account = self.paymentMethod as? AccountPaymentMethod {
            let number = account.accountNumber ?? "number?"
            return "Account ***" + number.suffix(2)
        } else {
            return "number?"
        }
    }
    
    var nameLine: String {
        if let card = self.paymentMethod as? CardPaymentMethod {
            return card.nameOnCard ?? "name?"
        } else if let account = self.paymentMethod as? AccountPaymentMethod {
            return account.nameOnAccount ?? "name?"
        } else {
            return "name?"
        }
    }
    
    var line3: String {
        if let card = self.paymentMethod as? CardPaymentMethod {
            return "Expires " + String(format: "%02d", card.expirationMonth) + "/" + String(card.expirationYear)
        } else if self.paymentMethod is AccountPaymentMethod {
            return "Checking Account"
        } else {
            return "name?"
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: self.isSelected ? "smallcircle.fill.circle.fill" : "circle")
                    .font(Font.system(size: 25, weight: .ultraLight))
                    .foregroundColor(Color(UIColor.link))
                    .onTapGesture {
                        self.selectedAction()
                    }
                .buttonStyle(BorderlessButtonStyle())
                Spacer()
                    .frame(width: 26)
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                        .frame(height: 8)
                    Text(self.numberLine)
                    Text(self.nameLine)
                    Text(self.line3)
                }
                Spacer()
            }
            if self.isSelected {
                Spacer()
                    .frame(height: 8)
                HStack {
                    Spacer()
                    StandardButton(action: self.navigationAction, labelText: "Pay with this \(self.paymentMethod is CardPaymentMethod ? "card" : "account")")
                    Spacer()
                }
            }
            Spacer()
                .frame(height: 8)
        }
    }
}


