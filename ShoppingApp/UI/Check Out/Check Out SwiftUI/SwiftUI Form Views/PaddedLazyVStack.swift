//
//  PaddedLazyVStack.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/4/21.
//

import SwiftUI

struct PaddedLazyVStack<Content>: View where Content : View {
    
    var content: () -> Content
    
    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        LazyVStack() {
            self.content()
        }
        .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 0))
    }
}


