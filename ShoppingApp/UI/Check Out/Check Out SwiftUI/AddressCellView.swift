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
    let navigationAction: () -> Void
    let editAction: () -> Void
    let selectedAction: (() -> Void)?
    
    var addressCityStateZipString: String {
        var str = ""
        str += (self.address.city ?? "city?")
        str += ", "
        str += (self.address.state ?? "state?")
        str += " "
        str += (self.address.zipCode ?? "zipCode?")
        return str
    }
    
    var body: some View {
        VStack {
            HStack {
                if let selectedAction = self.selectedAction {
                    Image(systemName: self.isSelected ? "smallcircle.fill.circle.fill" : "circle")
                        .font(Font.system(size: 25, weight: .ultraLight))
                        .foregroundColor(Color(UIConstants.secondaryButtonColor))
                        .onTapGesture {
                            selectedAction()
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    Spacer()
                        .frame(width: 26)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()
                        .frame(height: 8)
                    StandardText(address.fullName ?? "name?")
                    StandardText(address.streetAddress ?? "streetAddress?")
                    if let streetAddress2 = address.streetAddress2 {
                        StandardText(streetAddress2)
                    }
                    StandardText(self.addressCityStateZipString)
                }
                Spacer()
            }
            if self.isSelected {
                Spacer()
                    .frame(height: 8)
                HStack {
                    Spacer()
                    StandardButton(action: self.navigationAction, labelText: "Select this address")
                    Spacer()
                }
                Spacer()
                    .frame(height: 8)
                HStack {
                    Spacer()
                    StandardButton(action: self.editAction, labelText: "Edit")
                    Spacer()
                }
            }
            Spacer()
                .frame(height: 8)
        }
    }
}


