//
//  StandardButton2.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/29/21.
//

import SwiftUI

struct StandardButton2: View {
    
    let action: () -> Void
    let labelText: String
    
    var body: some View {
        Button(action: self.action, label: {
            StandardText(self.labelText, size: 15, style: .semiBold)
                .foregroundColor(Color(UIConstants.secondaryButtonColor))
        })
        .buttonStyle(PlainButtonStyle())
    }
}

