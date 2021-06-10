//
//  MenuTextField.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/31/21.
//

import SwiftUI

struct MenuTextField<ChoiceType: CustomStringConvertible>: View {
    
    @State private var choiceIndex: Int
    
    let choiceAction: (ChoiceType) -> Void
    
    let fontSize: CGFloat
    
    let choices: [ChoiceType]
    
    var text: String {
        guard choiceIndex != -1 else {
            return "--"
        }
        return self.choices[choiceIndex].description
    }
    
    init(choices: [ChoiceType], choiceAction: @escaping (ChoiceType) -> Void, initialChoice: ChoiceType?, fontSize: CGFloat? = nil) {
        let fontSize = fontSize ?? StandardTextField.standardFontSize
        self.choices = choices
        self.choiceAction = choiceAction
        self.fontSize = fontSize
        if let index = choices.firstIndex(where: {$0.description == initialChoice?.description}) {
            self.choiceIndex = index
        } else {
            self.choiceIndex = -1
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 0.5)
                .frame(height: self.fontSize + 24)
                .foregroundColor(.white)
            HStack {
                Text(self.text)
                    .font(Font(UIConstants.standardFont(size: self.fontSize, style: .regular)))
                    .padding(EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12))
                Spacer()
            }
            HStack {
                Spacer()
                Image(systemName: "chevron.down")
                Spacer()
                    .frame(width: 8)
            }
            Menu(content: {
                ForEach(0..<self.choices.count) { i in
                    Button(action: {
                        self.choiceIndex = i
                        self.choiceAction(self.choices[i])
                    }, label: { Text(self.choices[i].description) })
                }
            }, label: {
                Spacer()
                    .frame(height: self.fontSize + 24)
            })
            
        }
 
    }
}

