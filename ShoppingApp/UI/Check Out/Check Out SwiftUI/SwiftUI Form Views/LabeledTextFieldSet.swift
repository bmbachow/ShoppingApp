//
//  LabeledTextFieldSet.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/29/21.
//

import SwiftUI

struct LabeledTextFieldSet: View {
    
    private let labelText: String?
    
    let fields: [(titleKey: LocalizedStringKey, text: Binding<String>, textFieldType: StandardTextField.TextFieldType)]
    
    static let standardFontSize: CGFloat = 17
    let fontSize: CGFloat
    
    init(labelText: String?, fields: [(titleKey: LocalizedStringKey, text: Binding<String>, textFieldType: StandardTextField.TextFieldType)], fontSize: CGFloat? = nil) {
        let fontSize = fontSize ?? StandardTextField.standardFontSize
        self.labelText = labelText
        self.fields = fields
        self.fontSize = fontSize
    }
    
    var body: some View {
        LabeledVStack(labelText: self.labelText) {
            ForEach(0..<self.fields.count) { index in
                StandardTextField(self.fields[index].titleKey, text: self.fields[index].text, textFieldType: self.fields[index].textFieldType, fontSize: self.fontSize)
            }
        }
    }
}

