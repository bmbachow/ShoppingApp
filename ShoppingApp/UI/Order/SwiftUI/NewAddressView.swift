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
    
    @Binding var backButtonText: String
    @Binding var titleText: String
    @Binding var backButtonAction: () -> Void
    
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
            VStack(alignment: .center, spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Full name")
                    StandardTextField("", text: self.$nameText)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Address")
                    StandardTextField("Street address", text: self.$streetAddressText)
                    StandardTextField("Street address line 2 (optional)", text: self.$streetAddress2Text)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("City")
                    StandardTextField("", text: self.$cityText)
                }
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("State")
                        StandardTextField("", text: self.$stateText)
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Zip")
                        StandardTextField("", text: self.$zipCodeText)
                    }
                }
                Spacer()
                    .frame(height: 12)
                HStack {
                    Toggle("", isOn: self.$makeDefault)
                        .labelsHidden()
                    Text("Make this my default address")
                    Spacer()
                }
                Spacer()
                    .frame(height: 12)
                Button(action: self.saveAndSelectAddress, label: {
                    Text("Use this address")
                        .foregroundColor(Color(UIColor.link))
                        .fontWeight(.bold)
                })
                .buttonStyle(PlainButtonStyle())
                .disabled(self.shouldDisableSaveButton)
            }
            
            .padding(24)
            .onAppear(perform: {
                self.nameText = self.orderData.user.fullName
                self.backButtonText = "< Back"
                self.titleText = "New address"
                self.backButtonAction = {self.presentationMode.wrappedValue.dismiss()}
            })
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
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
                self.backButtonAction()
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
