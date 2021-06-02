//
//  MenuTextField.swift
//  ShoppingApp
//
//  Created by Robert Olieman on 5/31/21.
//

import SwiftUI

struct MenuTextField<ChoiceType: CustomStringConvertible>: View {
    
    @State private var choiceIndex: Int = 0
    let choiceAction: (ChoiceType) -> Void
    
    let fontSize: CGFloat
    
    let choices: [ChoiceType]
    
    init(choices: [ChoiceType], choiceAction: @escaping (ChoiceType) -> Void, fontSize: CGFloat? = nil) {
        let fontSize = fontSize ?? StandardTextField.standardFontSize
        self.choices = choices
        self.choiceAction = choiceAction
        self.fontSize = fontSize
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 0.5)
                .frame(height: self.fontSize + 24)
                .foregroundColor(.white)
            HStack {
                Text(self.choices[self.choiceIndex].description)
                    .font(.system(size: self.fontSize))
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

