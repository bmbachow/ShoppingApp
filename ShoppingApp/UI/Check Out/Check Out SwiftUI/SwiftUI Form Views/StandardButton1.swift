//
//  StandardButton1.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/7/21.
//

import Foundation
import SwiftUI

struct StandardButton1: View {
    
    let action: () -> Void
    let labelText: String
    
    var body: some View {
        Button(action: self.action, label: {
            StandardText(self.labelText, size: 15, style: .regular)
                .foregroundColor(.black)
        })
        .buttonStyle(PlainButtonStyle())
        .frame(width: 169, height: 30)
        .background(Color(UIConstants.accentColorApp))
        .cornerRadius(8)
    }
}

