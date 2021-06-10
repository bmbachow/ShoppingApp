//
//  NewAccountPaymentMethodView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/28/21.
//

import SwiftUI

struct NewAccountPaymentMethodView: View {
    
    let remoteAPI: RemoteAPI
    @ObservedObject var orderData: OrderData
    
    @State var nameOnAccount: String = ""
    @State var accountNumber: String = ""
    @State var routingNumber: String = ""
    
    @State var makeDefault: Bool = false
    
    var shouldDisableSaveButton: Bool {
        !self.nameOnAccountIsValid ||
            !self.accountNumberIsValid ||
            !self.routingNumberIsValid
    }
    
    @State var nameOnAccountIsValid = false
    @State var accountNumberIsValid = false
    @State var routingNumberIsValid = false

    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            FormVStack {
                LabeledTextFieldSet(labelText: "", fields: [
                    (titleKey: "Name on card", text: self.$nameOnAccount, textFieldType: .anyInput, inputIsValid: self.$nameOnAccountIsValid),
                    (titleKey: "Routing number", text: self.$routingNumber, textFieldType: .bankRoutingNumber, inputIsValid: self.$routingNumberIsValid),
                    (titleKey: "Account number", text: self.$accountNumber, textFieldType: .bankACcountNumber, inputIsValid: self.$accountNumberIsValid)
                ])
                FormSpacer()
                StandardToggle(isOn: self.$makeDefault, titleText: "Make this my default payment method")
                FormSpacer()
                StandardButton2(action: self.saveAndSelectAccountPaymentMethod, labelText: "Save account")
                    .disabled(self.shouldDisableSaveButton)
            }
        }
        //.modifier(ColorTopSafeArea(.white))
        .navigationTitle(Text("New checking account"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            self.nameOnAccount = self.orderData.user.fullName
        })
    }
    
    func saveAndSelectAccountPaymentMethod() {
        self.remoteAPI.postNewAccountPaymentMethod(
            user: self.orderData.user,
            nameOnAccount: self.nameOnAccount,
            accountNumber: self.accountNumber,
            routingNumber: self.routingNumber,
            isDefault: self.makeDefault,
            success: { accountPaymentMethod in
                self.orderData.paymentMethod = accountPaymentMethod
                self.presentationMode.wrappedValue.dismiss()
            },
            failure: { error in
                print(error.localizedDescription)
            })
    }
}

