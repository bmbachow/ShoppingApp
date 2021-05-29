//
//  FormHStack.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/29/21.
//

import SwiftUI

struct FormHStack<Content>: View where Content : View {
    
    var content: () -> Content
    
    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            self.content()
        }
    }
}
