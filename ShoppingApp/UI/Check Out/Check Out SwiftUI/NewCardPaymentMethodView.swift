//
//  NewCardPaymentMethodView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/28/21.
//

import SwiftUI

struct NewCardPaymentMethodView: View {
    
    let remoteAPI: RemoteAPI
    @ObservedObject var orderData: OrderData
    
    @State var nameOnCard: String = ""
    @State var cardNumber: String = ""
    
    @State var expirationMonth: Int = 1
    @State var expirationYear: Int = 2021
    
    @State var makeDefault: Bool = false
    
    var shouldDisableSaveButton: Bool {
        self.nameOnCard.isEmpty ||
            self.cardNumber.isEmpty
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            FormVStack {
                LabeledTextFieldSet(labelText: "", fields: [
                    (titleKey: "Name on card", text: self.$nameOnCard),
                    (titleKey: "Card number", text: self.$cardNumber)
                ])
                FormHStack {
                    LabeledVStack(labelText: "Expiration date") {
                        FormHStack {
                            MenuTextField(choices:  Month.allCases, choiceAction: { choice in
                                self.expirationMonth = choice.rawValue
                            })
                            MenuTextField(choices:  DateConstants.years, choiceAction: { choice in
                                self.expirationYear = choice
                            })
                        }
                    }
                }
                FormSpacer()
                StandardToggle(isOn: self.$makeDefault, titleText: "Make this my default payment method")
                FormSpacer()
                StandardButton(action: self.saveAndSelectCardPaymentMethod, labelText: "Save card")
                    .disabled(self.shouldDisableSaveButton)
            }
        }
        //.modifier(ColorTopSafeArea(.white))
        .navigationTitle(Text("New credit or debit card"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            self.nameOnCard = self.orderData.user.fullName
        })
    }
    
    func saveAndSelectCardPaymentMethod() {
        self.remoteAPI.postNewCardPaymentMethod(
            user: self.orderData.user,
            nameOnCard: self.nameOnCard,
            cardNumber: self.cardNumber,
            expirationMonth: self.expirationMonth,
            expirationYear: self.expirationYear,
            isDefault: self.makeDefault,
            success: { cardPaymentMethod in
                self.orderData.paymentMethod = cardPaymentMethod
                self.presentationMode.wrappedValue.dismiss()
            },
            failure: { error in
                print(error.localizedDescription)
            })
    }
}

