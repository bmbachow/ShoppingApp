//
//  LabeledVStack.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/31/21.
//

import Foundation
import SwiftUI

struct LabeledVStack<Content>: View where Content: View {
    
    private let labelText: String?
    
    var content: () -> Content
    
    init(labelText: String?, @ViewBuilder _ content: @escaping () -> Content) {
        self.labelText = labelText
        self.content = content
    }
    

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let labelText = self.labelText {
                Text(labelText)
                    .font(Font(UIConstants.standardFont(size: 14, style: .semiBold)))
            }
            self.content()
        }
    }
}

