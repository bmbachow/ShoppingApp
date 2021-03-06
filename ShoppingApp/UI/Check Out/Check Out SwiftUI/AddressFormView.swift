//
//  AddressFormView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import SwiftUI

struct AddressFormView: View {
    
    let remoteAPI: RemoteAPI
    @ObservedObject var orderData: OrderData
    
    @State private var nameText: String = ""
    @State private var streetAddressText: String = ""
    @State private var streetAddress2Text: String = ""
    @State private var cityText: String = ""
    @State private var stateText: String = ""
    @State private var zipCodeText: String = ""
    @State private var makeDefault = false
    
    var address: Address?
    
    var shouldDisableSaveButton: Bool {
        !self.nameTextIsValid ||
            !self.streetAddressTextIsValid ||
            !self.cityTextIsValid ||
            self.stateText.isEmpty ||
            !self.zipCodeTextIsValid
    }
    
    @State var nameTextIsValid = false
    @State var streetAddressTextIsValid = false
    @State var cityTextIsValid = false
    @State var zipCodeTextIsValid = false
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    init(remoteAPI: RemoteAPI, orderData: OrderData, address: Address?) {
        self.remoteAPI = remoteAPI
        self.orderData = orderData
        self.address = address
    }
    
    var body: some View {
        ScrollView {
            FormVStack {
                LabeledTextFieldSet(labelText: "Full name", fields: [
                    (titleKey: "", text: self.$nameText, textFieldType: .anyInput, inputIsValid: self.$nameTextIsValid),
                ])
                LabeledTextFieldSet(labelText: "Address", fields: [
                    (titleKey: "Street address", text: self.$streetAddressText, textFieldType: .anyInput, inputIsValid: self.$streetAddressTextIsValid),
                    (titleKey: "Street address line 2 (optional)", text: self.$streetAddress2Text, textFieldType: .none, inputIsValid: nil)
                ])
                LabeledTextFieldSet(labelText: "City", fields: [
                    (titleKey: "", text: self.$cityText, textFieldType: .anyInput, inputIsValid: self.$cityTextIsValid),
                ])
                FormHStack {
                    LabeledVStack(labelText: "State", {
                        MenuTextField(choices: USState.allCases, choiceAction: { usState in
                            self.stateText = usState.rawValue
                        }, initialChoice: { () -> USState? in
                            guard let initialChoiceRawValue = self.address?.state else {
                                return nil
                            }
                            return USState(rawValue: initialChoiceRawValue)
                        }(), noChoiceYetText: nil)
                    })
                    LabeledTextFieldSet(labelText: "Zip code", fields: [
                        (titleKey: "", text: self.$zipCodeText, textFieldType: .zipCode, inputIsValid: self.$zipCodeTextIsValid),
                    ])
                }
                //FormSpacer()
                HStack {
                    Spacer()
                StandardToggle(isOn: self.$makeDefault, titleText: "Make this my default address")
                    Spacer()
                }
                //FormSpacer()
                StandardButton1(action: {
                    self.saveAndSelectAddress()
                }, labelText: "Save address")
                .disabled(self.shouldDisableSaveButton)
            }
        }
        //.modifier(ColorTopSafeArea(.white))
        .navigationTitle(Text(self.address == nil ? "New address" : "Edit address"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            if let address = self.address {
                self.nameText = address.fullName ?? ""
                self.streetAddressText = address.streetAddress ?? ""
                self.streetAddress2Text = address.streetAddress2 ?? ""
                self.cityText = address.city ?? ""
                self.stateText = address.state ?? ""
                self.zipCodeText = address.zipCode ?? ""
                self.makeDefault = address.isDefault
            } else {
                self.nameText = self.orderData.user.fullName
            }
        })
    }
    
    func saveAndSelectAddress() {
        
        if let address = self.address {
            self.remoteAPI.patchAddress(
                address: address,
                fullName: self.nameText,
                streetAddress: self.streetAddressText,
                streetAddress2: self.streetAddress2Text.isEmpty
                                            ? nil : self.streetAddress2Text,
                city: self.cityText,
                state: self.stateText,
                zipCode: self.zipCodeText,
                isDefault: self.makeDefault,
                success: {_ in
                    self.orderData.address = address
                    self.presentationMode.wrappedValue.dismiss()
                }, failure: { error in
                    print(error.localizedDescription)
                })
        } else {
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
}

