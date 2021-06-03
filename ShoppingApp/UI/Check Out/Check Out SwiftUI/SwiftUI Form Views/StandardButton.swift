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
            StandardText(self.labelText, size: 17, style: .bold)
                .foregroundColor(Color(UIColor.link))
        })
        .buttonStyle(PlainButtonStyle())
    }
}

