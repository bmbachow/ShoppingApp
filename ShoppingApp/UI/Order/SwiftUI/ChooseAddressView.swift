//
//  ChooseAddressView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import SwiftUI

struct ChooseAddressView: View {
    
    let remoteAPI: RemoteAPI
    @ObservedObject var orderData: OrderData
    @Binding var backButtonText: String
    @Binding var titleText: String
    @Binding var backButtonAction: () -> Void
    
    let cancelAction: () -> Void
    
    var selectedAddress: Address? {
        if let address = orderData.address {
            return address
        }
        return orderData.user.defaultAddress
    }
    
    func isSelectedAddress(address: Address) -> Bool {
        let selected = address == self.selectedAddress
        return selected
    }
    
    var body: some View {
        List {
            if self.orderData.user.addressesArray.count > 0 {
                ForEach(self.orderData.user.addressesArray) { address in
                    let isSelected = self.isSelectedAddress(address: address)
                    AddressCellView(address: address, isSelected: isSelected)
                }
            } else {
                Text("You have no saved addresses")
            }
            NavigationLink(destination:
                            NewAddressView(remoteAPI: self.remoteAPI, orderData: self.orderData, backButtonText: self.$backButtonText, titleText: self.$titleText, backButtonAction: self.$backButtonAction),
                           label: {
                            Text("Add new address")
                                .foregroundColor(Color(UIColor.link))
                                .fontWeight(.bold)
                           })
        }
        .navigationBarHidden(true)
        .onAppear(perform: {
            self.backButtonText = "Cancel"
            self.titleText = "Shipping address"
            self.backButtonAction = self.cancelAction
        })
    }
}

/*
struct ChooseAddressView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseAddressView()
    }
}
*/
