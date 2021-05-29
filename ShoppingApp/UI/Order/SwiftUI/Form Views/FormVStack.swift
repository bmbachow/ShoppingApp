//
//  FormVStack.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/29/21.
//

import SwiftUI

struct FormVStack<Content>: View where Content : View {
    
    var content: () -> Content
    
    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            self.content()
        }
        .padding(24)
    }
}


