//
//  AddressCellView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import SwiftUI

struct AddressCellView: View {
    
    let address: Address
    
    var addressCityStateZipString: String {
        return (self.address.city ?? "city?") + ", " + (self.address.state ?? "state?") + " " + (self.address.zipCode ?? "zipCode?")
    }
    
    var body: some View {
        VStack {
            Text(address.streetAddress ?? "streetAddress?")
            if let streetAddress2 = address.streetAddress2 {
                Text(streetAddress2)
            }
            Text(self.addressCityStateZipString)
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
