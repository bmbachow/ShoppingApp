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
    let selectedAction: (() -> Void)?
    
    var indentSize: CGFloat = 24
    var addSeparator = true

    
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
    
    var buttonText: String {
        if self.paymentMethod is CardPaymentMethod {
            return "Pay with this card"
        } else if self.paymentMethod is AccountPaymentMethod {
            return "Pay with this account"
        } else {
            return "Pay cash on delivery"
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                    .frame(width: self.indentSize)
                if let selectedAction = self.selectedAction {
                    VStack {
                        Spacer()
                            .frame(height: 14)
                        Image(systemName: self.isSelected ? "smallcircle.fill.circle.fill" : "circle")
                            .font(Font.system(size: 25, weight: .ultraLight))
                            .foregroundColor(Color(UIConstants.secondaryButtonColor))
                            .onTapGesture {
                                selectedAction()
                            }
                            .buttonStyle(BorderlessButtonStyle())
                    }
                    Spacer()
                        .frame(width: 26)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                        .frame(height: 8)
                    if !(self.paymentMethod is CashOnDeliveryPaymentMethod) {
                        StandardText(self.numberLine)
                        StandardText(self.nameLine)
                        StandardText(self.line3)
                    } else {
                        StandardText("Cash on delivery")
                    }
                }
                Spacer()
            }
            if self.isSelected {
                Spacer()
                    .frame(height: 12)
                HStack {
                    Spacer()
                    StandardButton1(action: self.navigationAction, labelText: self.buttonText)
                    Spacer()
                }
            }
            Spacer()
                .frame(height: 14)
            if self.addSeparator {
                Separator()
            }
        }
    }
}


