//
//  StandardToggle.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/29/21.
//

import SwiftUI

struct StandardToggle: View {
    
    @Binding var isOn: Bool
    let titleText: String
    
    var body: some View {
        HStack {
            Toggle("", isOn: self.$isOn)
                .labelsHidden()
            Text(self.titleText)
                .font(Font(UIConstants.standardFont(size: 15, style: .regular)))
        }
    }
}
