//
//  StandardTextField.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/27/21.
//

import SwiftUI

struct StandardTextField: View {
    
    let titleKey: LocalizedStringKey
    private var text: Binding<String>
    
    static let standardFontSize: CGFloat = 17
    let fontSize: CGFloat
    
    init(_ titleKey: LocalizedStringKey, text: Binding<String>, fontSize: CGFloat? = nil) {
        let fontSize = fontSize ?? StandardTextField.standardFontSize
        self.titleKey = titleKey
        self.text = text
        self.fontSize = fontSize
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 0.5)
                .frame(height: self.fontSize + 24)
                .foregroundColor(.white)

            TextField(self.titleKey, text: self.text)
                .font(Font(UIConstants.standardFont(size: self.fontSize, style: .regular)))
                .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
        }
 
    }
}

/*
struct StandardTextField_Previews: PreviewProvider {
    static var previews: some View {
        StandardTextField()
    }
}
*/
