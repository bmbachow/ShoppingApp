//
//  StandardButton.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/29/21.
//

import SwiftUI

struct StandardButton: View {
    
    let action: () -> Void
    let labelText: String
    
    var body: some View {
        Button(action: self.action, label: {
            Text(self.labelText)
                .foregroundColor(Color(UIColor.link))
                .fontWeight(.bold)
        })
        .buttonStyle(PlainButtonStyle())
    }
}

