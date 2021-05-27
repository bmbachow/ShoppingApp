//
//  ChooseAddressView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import SwiftUI

struct ChooseAddressView: View {

    @ObservedObject var orderData: OrderData
    
    let cancelAction: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Spacer()
                        .frame(width: 12)
                    Button(action: self.cancelAction, label: {
                        Text("Cancel")
                            .foregroundColor(Color(UIColor.link))
                    })
                    Spacer()
                }
                Text("Shipping address")
                    .fontWeight(.bold)
            }
            List {
                if orderData.user.addressesArray.count > 0 {
                    ForEach(self.orderData.user.addressesArray) {address in
                        AddressCellView(address: address)
                    }
                } else {
                    Text("You have no saved addresses")
                }
                Button(action: {}, label: {
                    Text("Add new address")
                        .foregroundColor(Color(UIColor.link))
                        .fontWeight(.bold)
                })
            }
        }
    }
}

/*
struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        
    }
}
 */

