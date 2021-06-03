//
//  StandardText.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 6/2/21.
//

import SwiftUI

struct StandardText: View {
    
    var text: String
    
    var size: CGFloat?
    
    var style: FontStyle?
    
    static let standardSize: CGFloat = 17
    
    static let standardStyle: FontStyle = .regular
    
    init(_ text: String, size: CGFloat? = nil, style: FontStyle? = nil) {
        self.text = text
        self.size = size
        self.style = style
    }
    
    var body: some View {
        Text(self.text)
            .font(Font(UIConstants.standardFont(size: self.size ?? StandardText.standardSize, style: self.style ?? StandardText.standardStyle)))
    }
}

