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
    
    @State var expirationMonth: Int?
    @State var expirationYear: Int?
    
    @State var makeDefault: Bool = false
    
    var shouldDisableSaveButton: Bool {
        !self.nameOnCardIsValid ||
            !self.cardNumberIsValid ||
            self.expirationMonth == nil ||
            self.expirationYear == nil
    }

    @State var nameOnCardIsValid = false
    @State var cardNumberIsValid = false
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            FormVStack {
                LabeledTextFieldSet(labelText: "", fields: [
                    (titleKey: "Name on card", text: self.$nameOnCard, textFieldType: .anyInput, inputIsValid: self.$nameOnCardIsValid),
                    (titleKey: "Card number", text: self.$cardNumber, textFieldType: .cardNumber, inputIsValid: self.$cardNumberIsValid)
                ])
                FormHStack {
                    LabeledVStack(labelText: "Expiration date") {
                        FormHStack {
                            MenuTextField(choices: Month.allCases, choiceAction: { choice in
                                self.expirationMonth = choice.rawValue
                            }, initialChoice: nil)
                            MenuTextField(choices:  DateConstants.years, choiceAction: { choice in
                                self.expirationYear = choice
                            }, initialChoice: nil)
                        }
                    }
                }
                FormSpacer()
                StandardToggle(isOn: self.$makeDefault, titleText: "Make this my default payment method")
                FormSpacer()
                StandardButton2(action: self.saveAndSelectCardPaymentMethod, labelText: "Save card")
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
            expirationMonth: self.expirationMonth!,
            expirationYear: self.expirationYear!,
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

