//
//  AddressCellView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import SwiftUI

struct AddressCellView: View {
    
    let address: Address
    
    var isSelected: Bool
    
    var addressCityStateZipString: String {
        return (self.address.city ?? "city?") + ", " + (self.address.state ?? "state?") + " " + (self.address.zipCode ?? "zipCode?")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Spacer()
                .frame(height: 12)
            Text(address.streetAddress ?? "streetAddress?")
            if let streetAddress2 = address.streetAddress2 {
                Text(streetAddress2)
            }
            Text(self.addressCityStateZipString)
            if self.isSelected {
                HStack {
                    Spacer()
                    Button(action: {}, label: {
                        Text("Select this address")
                            .foregroundColor(Color(UIColor.link))
                            .fontWeight(.bold)
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    Spacer()
                }
                HStack {
                    Spacer()
                    Button(action: {}, label: {
                        Text("Edit")
                            .foregroundColor(Color(UIColor.link))
                            .fontWeight(.bold)
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    Spacer()
                }
            }
            Spacer()
                .frame(height: 12)
        }
    }
}


/*
struct AddressCellView_Previews: PreviewProvider {
    static var previews: some View {
        AddressCellView()
    }
}
*/
