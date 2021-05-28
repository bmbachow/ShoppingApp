//
//  AnimatingTextView.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import Foundation
import SwiftUI
import Combine

struct AnimatingTextView: View {
    
    @Binding var source: String
    var transitionTime: Double
    
    @State private var currentText: String? = nil
    @State private var visible: Bool = false
    
    private var font: Font
    
    private var publisher: AnyPublisher<[String.Element], Never> {
        source
            .publisher
            .collect()
            .eraseToAnyPublisher()
    }
    
    init(text: Binding<String>, font: Font, totalTransitionTime: Double) {
        self._source = text
        self.transitionTime = totalTransitionTime / 3
        self.font = font
    }
    
    private func update(_: Any) {
        guard currentText != nil else {
            currentText = source
            DispatchQueue.main.asyncAfter(deadline: .now() + (transitionTime)) {
                self.visible = true
            }
            return
        }
        guard source != currentText else { return }
        self.visible = false
        DispatchQueue.main.asyncAfter(deadline: .now() + (transitionTime)) {
            self.currentText = source
            DispatchQueue.main.asyncAfter(deadline: .now() + (transitionTime)) {
                self.visible = true
            }
        }
    }
    
    var body: some View {
        Text(currentText ?? "")
            .font(self.font)
            .opacity(visible ? 1 : 0)
            .offset(x: visible ? 0 : -50, y: 0)
            .animation(.linear(duration: transitionTime))
            .onReceive(publisher, perform: update(_:))
    }
    
}
