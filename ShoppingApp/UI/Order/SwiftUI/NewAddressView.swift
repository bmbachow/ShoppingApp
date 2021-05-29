//
//  NewAddressView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import SwiftUI

struct NewAddressView: View {
    
    let remoteAPI: RemoteAPI
    @ObservedObject var orderData: OrderData
    
    @State private var nameText: String = ""
    @State private var streetAddressText: String = ""
    @State private var streetAddress2Text: String = ""
    @State private var cityText: String = ""
    @State private var stateText: String = ""
    @State private var zipCodeText: String = ""
    @State private var makeDefault = false
    
    var shouldDisableSaveButton: Bool {
        self.nameText.isEmpty ||
            self.streetAddressText.isEmpty ||
            self.cityText.isEmpty ||
            self.stateText.isEmpty ||
            self.zipCodeText.isEmpty
    }
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        ScrollView {
            FormVStack {
                LabeledTextFieldSet(labelText: "Full name", fields: [
                    (titleKey: "", text: self.$nameText),
                ])
                LabeledTextFieldSet(labelText: "Address", fields: [
                    (titleKey: "Street address", text: self.$streetAddressText),
                    (titleKey: "Street address line 2 (optional)", text: self.$streetAddress2Text)
                ])
                LabeledTextFieldSet(labelText: "City", fields: [
                    (titleKey: "", text: self.$cityText),
                ])
                FormHStack {
                    LabeledTextFieldSet(labelText: "State", fields: [
                        (titleKey: "", text: self.$stateText),
                    ])
                    LabeledTextFieldSet(labelText: "Zip code", fields: [
                        (titleKey: "", text: self.$zipCodeText),
                    ])
                }
                FormSpacer()
                StandardToggle(isOn: self.$makeDefault, titleText: "Make this my default address")
                FormSpacer()
                StandardButton(action: {
                    self.saveAndSelectAddress()
                }, labelText: "Use this address")
                .disabled(self.shouldDisableSaveButton)
            }
        }
        .navigationTitle(Text("New address"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            self.nameText = self.orderData.user.fullName
        })
    }
    
    func saveAndSelectAddress() {
        self.remoteAPI.postNewAddress(
            user: self.orderData.user,
            fullName: self.nameText,
            streetAddress: self.streetAddressText,
            streetAddress2: self.streetAddress2Text.isEmpty
                ? nil : self.streetAddress2Text,
            city: self.cityText,
            state: self.stateText,
            zipCode: self.zipCodeText,
            isDefault: self.makeDefault, success: { address in
                self.orderData.address = address
                self.presentationMode.wrappedValue.dismiss()
            }, failure: { error in
                print(error.localizedDescription)
            })
    }
}
/*
struct NewAddressView_Previews: PreviewProvider {
    static var previews: some View {
        NewAddressView()
    }
}

*/
